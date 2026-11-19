package com.widucorp.widu.data.source

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener2
import android.hardware.SensorManager
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import com.widucorp.widu.data.model.ImuConfig
import com.widucorp.widu.data.model.ImuSample
import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.NonCancellable
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.withContext
import kotlinx.coroutines.withTimeoutOrNull
import javax.inject.Inject

class ImuLocalDataSourceImpl @Inject constructor(
    private val sensorManager: SensorManager,
) : ImuLocalDataSource {
    override fun samples(
        config: ImuConfig,
        onDrained: (List<ImuSample>) -> Unit,
    ): Flow<ImuSample> =
        flow {
            // 중력이 포함된 원래 가속도. TYPE_LINEAR_ACCELERATION 이 아니다. (A 1.6.2)
            val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
            if (sensor == null) {
                Log.w(TAG, "Accelerometer not available")
                return@flow
            }
            // 배치 한 개치(accHz × batchSec)가 FIFO 에 안 들어가면 FIFO 가 찰 때마다 AP 를 깨운다.
            Log.i(
                TAG,
                "Accelerometer ${sensor.name} wakeUp=${sensor.isWakeUpSensor} fifoReserved=${sensor.fifoReservedEventCount} fifoMax=${sensor.fifoMaxEventCount}",
            )

            val thread = HandlerThread("widyu-imu").apply { start() }
            /** 수집기가 받지 못한 샘플(FIFO 를 비운 것, 취소로 전달되지 못한 것). */
            val drained = mutableListOf<ImuSample>()
            // 버퍼를 두지 않고, 넘겼지만 취소로 처리되지 못한 샘플도 drained 로 돌린다.
            val channel = Channel<ImuSample>(Channel.RENDEZVOUS) { synchronized(drained) { drained += it } }
            val flushCompleted = CompletableDeferred<Unit>()
            val listener =
                object : SensorEventListener2 {
                    override fun onSensorChanged(event: SensorEvent) {
                        val sample =
                            ImuSample(
                                timestampNs = event.timestamp,
                                x = event.values[0],
                                y = event.values[1],
                                z = event.values[2],
                            )
                        if (channel.trySendBlocking(sample).isFailure) synchronized(drained) { drained += sample }
                    }

                    override fun onFlushCompleted(sensor: Sensor?) {
                        flushCompleted.complete(Unit)
                    }

                    override fun onAccuracyChanged(
                        sensor: Sensor?,
                        accuracy: Int,
                    ) = Unit
                }

            val registered =
                sensorManager.registerListener(
                    listener,
                    sensor,
                    MICROS_PER_SECOND / config.accHz,
                    // 센서 FIFO 가 배치 한 개치를 모으는 동안 CPU 가 잔다.
                    config.batchSec * MICROS_PER_SECOND,
                    Handler(thread.looper),
                )
            if (!registered) {
                Log.w(TAG, "Failed to register accelerometer listener")
                thread.quitSafely()
                return@flow
            }

            try {
                for (sample in channel) emit(sample)
            } finally {
                // 그냥 해제하면 FIFO 에 남은 최대 배치 한 개치가 버려진다. 비우고 나서 해제한다.
                // 채널을 먼저 닫아 이후 도착하는 샘플이 drained 로 가게 한다.
                channel.cancel()
                withContext(NonCancellable) {
                    if (sensorManager.flush(listener)) withTimeoutOrNull(DRAIN_TIMEOUT_MS) { flushCompleted.await() }
                    sensorManager.unregisterListener(listener)
                    thread.quitSafely()
                    // 닫힌 채널에 보내면 onUndeliveredElement 와 실패 처리가 같은 샘플을 두 번 넣을 수 있어 거른다.
                    // 취소로 돌아온 샘플과 FIFO 샘플이 섞여 들어올 수 있어 시각 순으로 넘긴다.
                    onDrained(synchronized(drained) { drained.distinct().sortedBy { it.timestampNs } })
                }
            }
        }

    private companion object {
        const val TAG = "Widyu"

        /** SM-R860 FIFO 는 300개(50Hz 6초치)라 5초 배치가 들어간다. */
        const val MICROS_PER_SECOND = 1_000_000

        /** FIFO 비우기를 기다리는 상한. 설정 변경·서비스 종료가 이만큼 늦어질 수 있다. */
        const val DRAIN_TIMEOUT_MS = 1_000L
    }
}
