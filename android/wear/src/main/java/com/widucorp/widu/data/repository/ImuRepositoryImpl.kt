package com.widucorp.widu.data.repository

import android.util.Log
import com.widucorp.widu.data.model.AxisSeries
import com.widucorp.widu.data.model.ClockInfo
import com.widucorp.widu.data.model.ImuBatch
import com.widucorp.widu.data.model.ImuConfig
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
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.NonCancellable
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.channelFlow
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
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
            // 모아 두었다가 [SendGate] 신호에 심박과 같은 순간에 보낸다.
            val pending = mutableListOf<ImuBatch>()
            val lock = Mutex()

            suspend fun flushPending() {
                val toSend = lock.withLock { pending.toList().also { pending.clear() } }
                withContext(ioDispatcher) { toSend.forEach { transmit(it, config) } }
            }

            val gateJob = launch { sendGate.ticks.collect { flushPending() } }

            val anchorJob =
                launch {
                    while (true) {
                        delay(TimeUnit.MINUTES.toMillis(config.anchorIntervalMin.toLong()))
                        clock = takeClock(clockMapper)
                    }
                }

            suspend fun emitAcc(series: AxisSeries) {
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
                // 전송이 실패해도 다음 배치는 계속 흐르도록 먼저 내보낸다.
                send(batch)
                rawLog?.flush()
                lock.withLock { pending += batch }
                sendGate.onData()
            }

            try {
                imuLocalDataSource.samples(config).collect { sample ->
                    rawLog?.appendLine("${sample.timestampNs},${sample.x},${sample.y},${sample.z}")
                    accBatcher.add(sample)?.let { emitAcc(it) }
                }
                accBatcher.flush()?.let { emitAcc(it) }
            } finally {
                anchorJob.cancel()
                gateJob.cancel()
                // 설정 변경·서비스 종료로 끊겨도 모아 둔 배치(최대 전송 주기치)를 버리지 않는다.
                withContext(NonCancellable) { flushPending() }
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

    /** 전송·정리 실패는 삼킨다. 배치 수집을 멈출 이유가 되지 않는다. */
    private suspend fun transmit(
        batch: ImuBatch,
        config: ImuConfig,
    ) {
        try {
            transmitOrThrow(batch, config)
        } catch (exception: CancellationException) {
            throw exception
        } catch (exception: Exception) {
            Log.w(TAG, "Failed to transmit batch seq=${batch.seq}", exception)
        }
    }

    private suspend fun transmitOrThrow(
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

    private companion object {
        const val TAG = "Widyu"
    }

    private fun takeClock(mapper: ClockMapper): ClockInfo {
        val anchor = clockLocalDataSource.takeAnchor()
        return mapper.onAnchor(clockLocalDataSource.bootId(), anchor.elapsedNs, anchor.epochMs, anchor.uncertaintyMs)
    }
}
