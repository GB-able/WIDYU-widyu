package com.gbable.widu.data.repository

import android.annotation.SuppressLint
import android.content.Context
import android.os.BatteryManager
import android.provider.Settings
import android.util.Log
import com.gbable.widu.BuildConfig
import com.gbable.widu.data.model.AxisSeries
import com.gbable.widu.data.model.ClockInfo
import com.gbable.widu.data.model.ImuBatch
import com.gbable.widu.data.model.ImuConfig
import com.gbable.widu.data.source.ClockLocalDataSource
import com.gbable.widu.data.source.ImuLocalDataSource
import com.gbable.widu.data.util.ClockMapper
import com.gbable.widu.data.util.ImuBatcher
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.channelFlow
import kotlinx.coroutines.launch
import java.io.BufferedWriter
import java.io.File
import java.io.FileOutputStream
import java.util.UUID
import java.util.concurrent.TimeUnit
import javax.inject.Inject

class ImuRepositoryImpl @Inject constructor(
    @ApplicationContext private val context: Context,
    private val imuLocalDataSource: ImuLocalDataSource,
    private val clockLocalDataSource: ClockLocalDataSource,
    private val config: ImuConfig,
) : ImuRepository {
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
            val rawLog = if (BuildConfig.DEBUG) openRawLog() else null

            val anchorJob =
                launch {
                    while (true) {
                        delay(TimeUnit.MINUTES.toMillis(config.anchorIntervalMin.toLong()))
                        clock = takeClock(clockMapper)
                    }
                }

            suspend fun emit(series: AxisSeries) {
                send(
                    ImuBatch(
                        batchId = UUID.randomUUID().toString(),
                        deviceId = deviceId(),
                        sessionId = sessionId,
                        seq = seq++,
                        clock = clock,
                        acc = series,
                        gyroMode = config.gyroMode,
                        collectionMode = config.collectionMode,
                        watchBatteryPct = batteryPercent(),
                    ),
                )
                rawLog?.flush()
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

    private fun takeClock(mapper: ClockMapper): ClockInfo {
        val anchor = clockLocalDataSource.takeAnchor()
        return mapper.onAnchor(clockLocalDataSource.bootId(), anchor.elapsedNs, anchor.epochMs, anchor.uncertaintyMs)
    }

    @SuppressLint("HardwareIds")
    private fun deviceId(): String = "gw-" + Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)

    private fun batteryPercent(): Int? =
        runCatching {
            (context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager)
                .getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }.getOrNull()

    /** 기기-1 측정용 원시 로그. adb pull 로 꺼낸다. 릴리스에서는 열지 않는다. */
    private fun openRawLog(): BufferedWriter? =
        runCatching {
            FileOutputStream(File(context.filesDir, "imu_raw.csv"), true).bufferedWriter()
        }.onFailure { Log.w(TAG, "Failed to open raw IMU log", it) }.getOrNull()

    private companion object {
        const val TAG = "Widyu"
    }
}
