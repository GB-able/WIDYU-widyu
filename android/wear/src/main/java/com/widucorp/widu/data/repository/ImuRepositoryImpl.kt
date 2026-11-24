package com.widucorp.widu.data.repository

import com.widucorp.widu.data.model.AxisSeries
import com.widucorp.widu.data.model.ClockInfo
import com.widucorp.widu.data.model.ImuBatch
import com.widucorp.widu.data.model.ImuConfig
import com.widucorp.widu.data.model.ImuSample
import com.widucorp.widu.data.source.ClockLocalDataSource
import com.widucorp.widu.data.source.DeviceInfoLocalDataSource
import com.widucorp.widu.data.source.ImuConfigLocalDataSource
import com.widucorp.widu.data.source.ImuLocalDataSource
import com.widucorp.widu.data.source.ImuRemoteDataSource
import com.widucorp.widu.data.util.ClockMapper
import com.widucorp.widu.data.util.DropReason
import com.widucorp.widu.data.util.ImuBatcher
import com.widucorp.widu.data.util.OnBodyStateHolder
import com.widucorp.widu.data.util.SendGate
import com.widucorp.widu.data.util.newUlid
import com.widucorp.widu.data.util.toRanges
import com.widucorp.widu.di.IoDispatcher
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.NonCancellable
import kotlinx.coroutines.cancelAndJoin
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.channelFlow
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.UUID
import java.util.concurrent.TimeUnit
import javax.inject.Inject

class ImuRepositoryImpl @Inject constructor(
    private val imuLocalDataSource: ImuLocalDataSource,
    private val clockLocalDataSource: ClockLocalDataSource,
    private val deviceInfoLocalDataSource: DeviceInfoLocalDataSource,
    private val imuRemoteDataSource: ImuRemoteDataSource,
    private val imuConfigLocalDataSource: ImuConfigLocalDataSource,
    private val onBodyStateHolder: OnBodyStateHolder,
    private val sendGate: SendGate,
    @IoDispatcher private val ioDispatcher: CoroutineDispatcher,
) : ImuRepository {
    /** 서버 설정이 바뀌면 센서 등록·배처를 버리고 새 세션으로 다시 시작한다(seq 0 부터). */
    @OptIn(ExperimentalCoroutinesApi::class)
    override fun batches(): Flow<ImuBatch> = imuConfigLocalDataSource.config().flatMapLatest { collect(it) }

    private fun collect(config: ImuConfig): Flow<ImuBatch> =
        channelFlow {
            val sessionId = UUID.randomUUID().toString()
            val clockMapper = ClockMapper(config.clockJumpToleranceMs)
            val accBatcher = ImuBatcher(TimeUnit.SECONDS.toNanos(config.batchSec.toLong()), config.accHz)
            var clock: ClockInfo = takeClock(clockMapper)
            var seq = 0L
            val rawLog = deviceInfoLocalDataSource.openRawLog()
            /** 수집이 취소될 때 센서 FIFO 에서 비운 샘플. */
            var drained: List<ImuSample> = emptyList()
            // 모아 두었다가 [SendGate] 신호에 심박과 같은 순간에 보낸다.
            // 잠금 안에서는 suspend 하지 않는다. synchronized 는 대기 중 취소되지 않아 닫힌 배치를 놓치지 않는다.
            val pending = mutableListOf<ImuBatch>()

            /** 보낸 뒤에 목록에서 뺀다. 도중에 취소돼도 남은 배치는 종료 처리가 보낸다(같은 seq 경로라 다시 넣어도 덮어쓴다). */
            suspend fun flushPending() {
                while (true) {
                    val batch = synchronized(pending) { pending.firstOrNull() } ?: return
                    withContext(ioDispatcher) { transmit(batch, config) }
                    synchronized(pending) { pending.remove(batch) }
                }
            }

            val gateJob = launch { sendGate.ticks.collect { flushPending() } }

            val anchorJob =
                launch {
                    while (true) {
                        delay(TimeUnit.MINUTES.toMillis(config.anchorIntervalMin.toLong()))
                        clock = takeClock(clockMapper)
                    }
                }

            /** 전송 목록에 먼저 넣는다. 화면 쪽 [send] 가 대기하다 취소돼도 배치는 남는다. */
            suspend fun enqueue(series: AxisSeries): ImuBatch {
                val (onBody, wearState) = wearFields()
                val batch =
                    ImuBatch(
                        batchId = newUlid(),
                        deviceId = deviceInfoLocalDataSource.deviceId(),
                        sessionId = sessionId,
                        seq = seq++,
                        clock = clock,
                        acc = series,
                        gyroMode = config.gyroMode,
                        collectionMode = config.collectionMode,
                        onBody = onBody,
                        wearState = wearState,
                        watchBatteryPct = deviceInfoLocalDataSource.batteryPercent(),
                    )
                synchronized(pending) { pending += batch }
                return batch
            }

            suspend fun emitAcc(series: AxisSeries) {
                send(enqueue(series))
                rawLog?.flush()
                sendGate.onData()
            }

            fun batch(sample: ImuSample): AxisSeries? {
                rawLog?.appendLine("${sample.timestampNs},${sample.x},${sample.y},${sample.z}")
                return accBatcher.add(sample)
            }

            try {
                imuLocalDataSource.samples(config) { drained = it }.collect { sample -> batch(sample)?.let { emitAcc(it) } }
                accBatcher.flush()?.let { emitAcc(it) }
            } finally {
                anchorJob.cancel()
                // 설정 변경·서비스 종료로 끊겨도 모아 둔 배치(최대 전송 주기치)와 열린 배치, FIFO 에 남아 있던 샘플을 버리지 않는다.
                withContext(NonCancellable) {
                    gateJob.cancelAndJoin()
                    drained.forEach { sample -> batch(sample)?.let { enqueue(it) } }
                    accBatcher.flush()?.let { enqueue(it) }
                    flushPending()
                }
                runCatching { rawLog?.close() }
            }
        }

    /**
     * 서버는 `on_body` boolean 필수, 정책서는 미관측을 false 로 떨구지 말라고 한다.
     * 절충으로 미관측일 때 true 를 보내고, 실제 상태는 `wear_state` 의 `UNKNOWN` 으로 구분한다.
     * 두 값이 어긋나지 않도록 착용 상태를 한 번만 읽는다.
     */
    private fun wearFields(): Pair<Boolean, String> {
        val observed = onBodyStateHolder.state.value
        return (observed ?: true) to onBodyStateHolder.wearState(observed)
    }

    /** 원격 호출은 실패를 삼키고(runSafely) 결과로만 알려 주므로 여기서는 잡지 않는다. */
    private suspend fun transmit(
        batch: ImuBatch,
        config: ImuConfig,
    ) {
        if (!imuRemoteDataSource.sendBatch(batch)) {
            imuRemoteDataSource.recordDrop(batch.sessionId, batch.seq, batch.seq, DropReason.ENQUEUE_FAILED)
        }
        if (batch.seq % config.trimEverySeq != 0L) return

        // 워치에 쌓아 둘 배치 상한. 기본 30분치(5초 배치면 360개).
        val maxQueuedBatches = config.queueMinutes * 60 / config.batchSec
        val dropped = imuRemoteDataSource.trimQueue(batch.sessionId, maxQueuedBatches)
        if (dropped.isEmpty()) return
        dropped.toRanges().forEach { range ->
            imuRemoteDataSource.recordDrop(batch.sessionId, range.first, range.last, DropReason.QUEUE_OVERFLOW)
        }
    }

    private fun takeClock(mapper: ClockMapper): ClockInfo {
        val anchor = clockLocalDataSource.takeAnchor()
        return mapper.onAnchor(clockLocalDataSource.bootId(), anchor.elapsedNs, anchor.epochMs, anchor.uncertaintyMs)
    }
}
