package com.gbable.widu.data.repository

import android.util.Log
import com.gbable.widu.data.model.ClockInfo
import com.gbable.widu.data.model.HeartRateBatch
import com.gbable.widu.data.model.HeartRateStatus
import com.gbable.widu.data.model.MeasureResult
import com.gbable.widu.data.source.ClockLocalDataSource
import com.gbable.widu.data.source.DeviceInfoLocalDataSource
import com.gbable.widu.data.source.HeartRateLocalDataSource
import com.gbable.widu.data.source.HeartRateRemoteDataSource
import com.gbable.widu.data.util.ClockMapper
import com.gbable.widu.data.util.OnBodyStateHolder
import com.gbable.widu.data.util.newUlid
import com.gbable.widu.data.util.toBatchSamples
import com.gbable.widu.di.ApplicationScope
import com.gbable.widu.di.IoDispatcher
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.channelFlow
import kotlinx.coroutines.flow.shareIn
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.UUID
import javax.inject.Inject

class HeartRateRepositoryImpl @Inject constructor(
    private val heartRateLocalDataSource: HeartRateLocalDataSource,
    private val heartRateRemoteDataSource: HeartRateRemoteDataSource,
    private val clockLocalDataSource: ClockLocalDataSource,
    private val deviceInfoLocalDataSource: DeviceInfoLocalDataSource,
    private val onBodyStateHolder: OnBodyStateHolder,
    @IoDispatcher private val ioDispatcher: CoroutineDispatcher,
    @ApplicationScope applicationScope: CoroutineScope,
) : HeartRateRepository {
    /**
     * 센서가 준 묶음을 그 샘플 전부와 각자의 잰 시각으로 바로 보낸다.
     * 최근 값을 주기적으로 다시 보내지 않는다 — 같은 값이 새 시각으로 복제되면 연구 자료가 오염된다. (지시서 F6)
     */
    private val heartRates: SharedFlow<MeasureResult> =
        channelFlow {
            val sessionId = UUID.randomUUID().toString()
            val clockMapper = ClockMapper(CLOCK_JUMP_TOLERANCE_MS)
            var clock = takeClock(clockMapper)
            var seq = 0L

            val anchorJob =
                launch {
                    while (true) {
                        delay(ANCHOR_INTERVAL_MS)
                        clock = takeClock(clockMapper)
                    }
                }

            try {
                heartRateLocalDataSource.getMeasureResult().collect { measureResult ->
                    send(measureResult)
                    when (measureResult) {
                        is MeasureResult.HeartRate -> {
                            val batches =
                                measureResult.readings.toBatchSamples(clock).map { samples ->
                                    HeartRateBatch(
                                        batchId = newUlid(),
                                        deviceId = deviceInfoLocalDataSource.deviceId(),
                                        sessionId = sessionId,
                                        seq = seq++,
                                        clock = clock,
                                        samples = samples,
                                        // 서버는 boolean 필수다. 미관측이면 false 로 떨구지 않고 true 로 둔다(IMU 와 같은 절충).
                                        onBody = onBodyStateHolder.state.value ?: true,
                                        watchBatteryPct = deviceInfoLocalDataSource.batteryPercent(),
                                    )
                                }
                            withContext(ioDispatcher) {
                                batches.forEach { transmit(it) }
                                measureResult.value?.let { heartRateRemoteDataSource.sendHeartRate(it) }
                            }
                        }

                        MeasureResult.SessionSuperseded -> Unit

                        is MeasureResult.Availability ->
                            measureResult.isOnBody?.let(onBodyStateHolder::update) ?: Unit
                    }
                }
            } finally {
                anchorJob.cancel()
            }
        }.shareIn(
            scope = applicationScope,
            started = SharingStarted.Lazily,
            replay = 1,
        )

    override suspend fun hasHeartRateCapability(): Result<Boolean> = runCatching { heartRateLocalDataSource.hasHeartRateCapability() }

    override fun getHeartRate(): Flow<MeasureResult> = heartRates

    override fun getHeartRateStatus(): Flow<HeartRateStatus> = heartRateRemoteDataSource.fetchHeartRateStatus()

    override suspend fun restartSession() = heartRateLocalDataSource.restartSession()

    /** 전송·정리 실패는 삼킨다. 측정을 멈출 이유가 되지 않는다. */
    private suspend fun transmit(batch: HeartRateBatch) {
        try {
            heartRateRemoteDataSource.sendBatch(batch)
            if (batch.seq % TRIM_EVERY_SEQ != 0L) return
            val dropped = heartRateRemoteDataSource.trimQueue(batch.sessionId, QUEUE_MAX)
            if (dropped.isNotEmpty()) Log.w(TAG, "Heart rate queue full; dropped seq=${dropped.min()}..${dropped.max()}")
        } catch (exception: CancellationException) {
            throw exception
        } catch (exception: Exception) {
            Log.w(TAG, "Failed to transmit heart rate batch seq=${batch.seq}", exception)
        }
    }

    private fun takeClock(mapper: ClockMapper): ClockInfo {
        val anchor = clockLocalDataSource.takeAnchor()
        return mapper.onAnchor(clockLocalDataSource.bootId(), anchor.elapsedNs, anchor.epochMs, anchor.uncertaintyMs)
    }

    private companion object {
        const val TAG = "Widyu"
        const val ANCHOR_INTERVAL_MS = 10 * 60 * 1_000L
        const val CLOCK_JUMP_TOLERANCE_MS = 50.0

        /** 센서가 약 5초마다 한 묶음을 주므로 1시간치. */
        const val QUEUE_MAX = 720
        const val TRIM_EVERY_SEQ = 12L
    }
}
