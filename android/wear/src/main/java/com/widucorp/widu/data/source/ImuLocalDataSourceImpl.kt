package com.widucorp.widu.data.source

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import com.widucorp.widu.data.model.ImuConfig
import com.widucorp.widu.data.model.ImuSample
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import javax.inject.Inject

class ImuLocalDataSourceImpl @Inject constructor(
    private val sensorManager: SensorManager,
) : ImuLocalDataSource {
    override fun samples(config: ImuConfig): Flow<ImuSample> =
        callbackFlow {
            // 중력이 포함된 원래 가속도. TYPE_LINEAR_ACCELERATION 이 아니다. (A 1.6.2)
            val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
            if (sensor == null) {
                Log.w(TAG, "Accelerometer not available")
                close()
                return@callbackFlow
            }
            // 배치 한 개치(accHz × batchSec)가 FIFO 에 안 들어가면 FIFO 가 찰 때마다 AP 를 깨운다.
            Log.i(
                TAG,
                "Accelerometer ${sensor.name} wakeUp=${sensor.isWakeUpSensor} fifoReserved=${sensor.fifoReservedEventCount} fifoMax=${sensor.fifoMaxEventCount}",
            )

            val thread = HandlerThread("widyu-imu").apply { start() }
            val listener =
                object : SensorEventListener {
                    override fun onSensorChanged(event: SensorEvent) {
                        trySendBlocking(
                            ImuSample(
                                timestampNs = event.timestamp,
                                x = event.values[0],
                                y = event.values[1],
                                z = event.values[2],
                            ),
                        )
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
                close()
                return@callbackFlow
            }

            awaitClose {
                sensorManager.unregisterListener(listener)
                thread.quitSafely()
            }
        }

    private companion object {
        const val TAG = "Widyu"

        /** SM-R860 FIFO 는 300개(50Hz 6초치)라 5초 배치가 들어간다. */
        const val MICROS_PER_SECOND = 1_000_000
    }
}
