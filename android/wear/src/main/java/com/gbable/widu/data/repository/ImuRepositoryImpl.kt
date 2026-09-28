package com.gbable.widu.data.repository

import android.util.Log
import com.gbable.widu.data.model.AxisSeries
import com.gbable.widu.data.model.ClockInfo
import com.gbable.widu.data.model.ImuBatch
import com.gbable.widu.data.model.ImuConfig
import com.gbable.widu.data.source.ClockLocalDataSource
import com.gbable.widu.data.source.DeviceInfoLocalDataSource
import com.gbable.widu.data.source.ImuLocalDataSource
import com.gbable.widu.data.source.ImuRemoteDataSource
import com.gbable.widu.data.util.ClockMapper
import com.gbable.widu.data.util.ImuBatcher
import com.gbable.widu.di.IoDispatcher
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.channelFlow
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
    private val config: ImuConfig,
    @IoDispatcher private val ioDispatcher: CoroutineDispatcher,
) : ImuRepository {
    /** 워치에 쌓아 둘 배치 상한. 기본 10분치(1초 배치면 600개). */
    private val maxQueuedBatches: Int get() = config.queueMinutes * 60 / config.batchSec

    override fun batches(): Flow<ImuBatch> =
        channelFlow {
            val sessionId = UUID.randomUUID().toString()
            val clockMapper = ClockMapper(config.clockJumpToleranceMs)
            val batcher =
                ImuBatcher(
                    batchNs = TimeUnit.SECONDS.toNanos(config.batchSec.toLong()),
                    fsHzRequested = config.accHz,
                )
            var clock: ClockInfo = takeClock(clockMapper)
            var seq = 0L
            val rawLog = deviceInfoLocalDataSource.openRawLog()

            val anchorJob =
                launch {
                    while (true) {
                        delay(TimeUnit.MINUTES.toMillis(config.anchorIntervalMin.toLong()))
                        clock = takeClock(clockMapper)
                    }
                }

            suspend fun emit(series: AxisSeries) {
                val batch =
                    ImuBatch(
                        batchId = UUID.randomUUID().toString(),
                        deviceId = deviceInfoLocalDataSource.deviceId(),
                        sessionId = sessionId,
                        seq = seq++,
                        clock = clock,
                        acc = series,
                        gyroMode = config.gyroMode,
                        collectionMode = config.collectionMode,
                        watchBatteryPct = deviceInfoLocalDataSource.batteryPercent(),
                    )
                // 먼저 내보내고 전송한다. 전송이 실패해도 다음 배치는 계속 흐른다.
                send(batch)
                rawLog?.flush()
                withContext(ioDispatcher) { transmit(batch) }
            }

            try {
                imuLocalDataSource.samples().collect { sample ->
                    rawLog?.appendLine("${sample.timestampNs},${sample.x},${sample.y},${sample.z}")
                    batcher.add(sample)?.let { emit(it) }
                }
                batcher.flush()?.let { emit(it) }
            } finally {
                anchorJob.cancel()
                runCatching { rawLog?.close() }
            }
        }

    /** 전송·정리 실패는 삼킨다. 배치 수집을 멈출 이유가 되지 않는다. */
    private suspend fun transmit(batch: ImuBatch) {
        try {
            transmitOrThrow(batch)
        } catch (exception: CancellationException) {
            throw exception
        } catch (exception: Exception) {
            Log.w(TAG, "Failed to transmit batch seq=${batch.seq}", exception)
        }
    }

    private suspend fun transmitOrThrow(batch: ImuBatch) {
        imuRemoteDataSource.sendBatch(batch)
        if (batch.seq % config.trimEverySeq != 0L) return

        val dropped = imuRemoteDataSource.trimQueue(batch.sessionId, maxQueuedBatches)
        if (dropped.isEmpty()) return
        imuRemoteDataSource.recordDrop(batch.sessionId, dropped.min(), dropped.max())
    }

    private companion object {
        const val TAG = "Widyu"
    }

    private fun takeClock(mapper: ClockMapper): ClockInfo {
        val anchor = clockLocalDataSource.takeAnchor()
        return mapper.onAnchor(clockLocalDataSource.bootId(), anchor.elapsedNs, anchor.epochMs, anchor.uncertaintyMs)
    }
}
