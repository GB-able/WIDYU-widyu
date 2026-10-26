package com.widucorp.widu.data.repository

import android.util.Log
import com.widucorp.widu.data.model.AxisSeries
import com.widucorp.widu.data.model.ClockInfo
import com.widucorp.widu.data.model.ImpactTrigger
import com.widucorp.widu.data.model.ImuBatch
import com.widucorp.widu.data.model.ImuConfig
import com.widucorp.widu.data.model.ImuSample
import com.widucorp.widu.data.model.MissingReason
import com.widucorp.widu.data.source.ClockLocalDataSource
import com.widucorp.widu.data.source.DeviceInfoLocalDataSource
import com.widucorp.widu.data.source.ImuConfigLocalDataSource
import com.widucorp.widu.data.source.ImuLocalDataSource
import com.widucorp.widu.data.source.ImuRemoteDataSource
import com.widucorp.widu.data.util.ClockMapper
import com.widucorp.widu.data.util.GyroRingBuffer
import com.widucorp.widu.data.util.ImpactDetector
import com.widucorp.widu.data.util.ImuBatcher
import com.widucorp.widu.data.util.OnBodyStateHolder
import com.widucorp.widu.data.util.newUlid
import com.widucorp.widu.di.IoDispatcher
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.ExperimentalCoroutinesApi
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
    @IoDispatcher private val ioDispatcher: CoroutineDispatcher,
) : ImuRepository {
    /** 서버 설정이 바뀌면 센서 등록·배처·링버퍼를 버리고 새 세션으로 다시 시작한다(seq 0 부터). */
    @OptIn(ExperimentalCoroutinesApi::class)
    override fun batches(): Flow<ImuBatch> = imuConfigLocalDataSource.config().flatMapLatest { collect(it) }

    private fun collect(config: ImuConfig): Flow<ImuBatch> =
        channelFlow {
            val sessionId = UUID.randomUUID().toString()
            val clockMapper = ClockMapper(config.clockJumpToleranceMs)
            val batchNs = TimeUnit.SECONDS.toNanos(config.batchSec.toLong())
            // 두 축은 시간축이 따로다. 샘플 수·t0 가 달라도 된다. (부록 A)
            val accBatcher = ImuBatcher(batchNs, config.accHz)
            val gyroBatcher = ImuBatcher(batchNs, config.accHz)
            val ringBuffer = GyroRingBuffer(TimeUnit.SECONDS.toNanos(config.backfillPreSec.toLong()))
            val detector = ImpactDetector(config.impactG)
            val hasGyroscope = imuLocalDataSource.hasGyroscope()
            val isResearch = config.collectionMode == RESEARCH_MODE
            var clock: ClockInfo = takeClock(clockMapper)
            var seq = 0L
            var closedGyro: AxisSeries? = null
            /** 보강 창의 끝. 이 시각까지 닫히는 배치에는 자이로를 싣는다. */
            var postWindowEndNs = Long.MIN_VALUE
            val rawLog = deviceInfoLocalDataSource.openRawLog()

            val anchorJob =
                launch {
                    while (true) {
                        delay(TimeUnit.MINUTES.toMillis(config.anchorIntervalMin.toLong()))
                        clock = takeClock(clockMapper)
                    }
                }

            suspend fun emit(
                batch: ImuBatch,
                urgent: Boolean,
            ) {
                // 전송이 실패해도 다음 배치는 계속 흐르도록 먼저 내보낸다.
                send(batch)
                rawLog?.flush()
                withContext(ioDispatcher) { transmit(batch, urgent, config) }
            }

            /** [nowNs] 는 배치가 닫힌 시각. */
            suspend fun emitAcc(
                series: AxisSeries,
                nowNs: Long,
                trigger: ImpactTrigger?,
            ): ImuBatch {
                val gyro = closedGyro?.also { closedGyro = null } ?: gyroBatcher.flush()
                // 연구 세션 모드에는 평시 생략이 없다. 제품 모드는 보강 창 안에서만 싣는다. (A 1.6.4)
                val attach = hasGyroscope && (isResearch || nowNs <= postWindowEndNs)
                val batch =
                    ImuBatch(
                        batchId = newUlid(),
                        deviceId = deviceInfoLocalDataSource.deviceId(),
                        sessionId = sessionId,
                        seq = seq++,
                        clock = clock,
                        acc = series,
                        // 자이로가 없으면 null 이다. 0 으로 채우지 않는다. (A 1.2.6)
                        gyro = if (attach) gyro else null,
                        trigger = trigger,
                        gyroMode = config.gyroMode,
                        collectionMode = config.collectionMode,
                        missingReason =
                            when {
                                !hasGyroscope -> MissingReason.SENSOR_UNSUPPORTED
                                attach -> null
                                else -> MissingReason.OMITTED_BY_MODE
                            },
                        onBody = onBody(),
                        wearState = wearState(),
                        watchBatteryPct = deviceInfoLocalDataSource.batteryPercent(),
                    )
                emit(batch, urgent = trigger != null)
                return batch
            }

            suspend fun emitBackfill(
                eventNs: Long,
                impactBatch: ImuBatch,
            ) {
                val series = ImuBatcher.samplesToSeries(ringBuffer.takeBefore(eventNs), config.accHz) ?: return
                emit(
                    ImuBatch(
                        batchId = newUlid(),
                        deviceId = deviceInfoLocalDataSource.deviceId(),
                        sessionId = sessionId,
                        seq = seq++,
                        clock = clock,
                        acc = null,
                        gyro = series,
                        gyroBackfill = true,
                        backfillFor = impactBatch.batchId,
                        gyroMode = config.gyroMode,
                        collectionMode = config.collectionMode,
                        onBody = onBody(),
                        wearState = wearState(),
                        watchBatteryPct = deviceInfoLocalDataSource.batteryPercent(),
                    ),
                    urgent = true,
                )
            }

            try {
                imuLocalDataSource.samples(config).collect { sample ->
                    rawLog?.appendLine("${sample.timestampNs},${sample.x},${sample.y},${sample.z}")
                    if (sample.type == ImuSample.Type.GYRO) {
                        ringBuffer.add(sample)
                        gyroBatcher.add(sample)?.let { closedGyro = it }
                        return@collect
                    }

                    // 배치 절단 기준은 가속도다.
                    accBatcher.add(sample)?.let { emitAcc(it, sample.timestampNs, trigger = null) }

                    val smvG = detector.check(sample) ?: return@collect
                    val eventNs = sample.timestampNs
                    // 창이 활성인 동안의 문턱 초과는 같은 충격의 연속이다. 창만 연장해야
                    // 스파이크가 지속되는 수 샘플마다 1샘플짜리 trigger 배치가 연달아 나가지 않는다.
                    val windowWasActive = eventNs <= postWindowEndNs
                    postWindowEndNs = eventNs + TimeUnit.SECONDS.toNanos(config.backfillPostSec.toLong())
                    if (windowWasActive) return@collect
                    val trigger =
                        ImpactTrigger(
                            smvG = smvG,
                            eventElapsedNs = eventNs,
                            tsMs = clock.anchorEpochMs + (eventNs - clock.anchorElapsedNs) / NANOS_PER_MILLI,
                        )
                    val impactBatch = accBatcher.flush()?.let { emitAcc(it, eventNs, trigger) } ?: return@collect
                    emitBackfill(eventNs, impactBatch)
                }
                accBatcher.flush()?.let { emitAcc(it, it.t0ElapsedNs, trigger = null) }
            } finally {
                anchorJob.cancel()
                runCatching { rawLog?.close() }
            }
        }

    /**
     * 서버는 `on_body` boolean 필수, 정책서는 미관측을 false 로 떨구지 말라고 한다.
     * 절충으로 미관측일 때 true + [wearState] `unknown` 을 보낸다. 서버 규약이 확정되면 여기만 바꾼다.
     */
    private fun onBody(): Boolean = onBodyStateHolder.state.value ?: true

    private fun wearState(): String? = if (onBodyStateHolder.state.value == null) WEAR_STATE_UNKNOWN else null

    /** 전송·정리 실패는 삼킨다. 배치 수집을 멈출 이유가 되지 않는다. */
    private suspend fun transmit(
        batch: ImuBatch,
        urgent: Boolean,
        config: ImuConfig,
    ) {
        try {
            transmitOrThrow(batch, urgent, config)
        } catch (exception: CancellationException) {
            throw exception
        } catch (exception: Exception) {
            Log.w(TAG, "Failed to transmit batch seq=${batch.seq}", exception)
        }
    }

    private suspend fun transmitOrThrow(
        batch: ImuBatch,
        urgent: Boolean,
        config: ImuConfig,
    ) {
        imuRemoteDataSource.sendBatch(batch, urgent)
        if (batch.seq % config.trimEverySeq != 0L) return

        // 워치에 쌓아 둘 배치 상한. 기본 30분치(1초 배치면 1800개).
        val maxQueuedBatches = config.queueMinutes * 60 / config.batchSec
        val dropped = imuRemoteDataSource.trimQueue(batch.sessionId, maxQueuedBatches)
        if (dropped.isEmpty()) return
        imuRemoteDataSource.recordDrop(batch.sessionId, dropped.min(), dropped.max())
    }

    private companion object {
        const val TAG = "Widyu"
        const val RESEARCH_MODE = "research"
        const val NANOS_PER_MILLI = 1_000_000L
        const val WEAR_STATE_UNKNOWN = "unknown"
    }

    private fun takeClock(mapper: ClockMapper): ClockInfo {
        val anchor = clockLocalDataSource.takeAnchor()
        return mapper.onAnchor(clockLocalDataSource.bootId(), anchor.elapsedNs, anchor.epochMs, anchor.uncertaintyMs)
    }
}
