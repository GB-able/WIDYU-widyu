package com.gbable.widu.data.source

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Handler
import android.os.HandlerThread
import android.util.Log
import com.gbable.widu.data.model.ImuConfig
import com.gbable.widu.data.model.ImuSample
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import javax.inject.Inject

class ImuLocalDataSourceImpl @Inject constructor(
    private val sensorManager: SensorManager,
) : ImuLocalDataSource {
    override fun hasGyroscope(): Boolean = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE) != null

    override fun samples(config: ImuConfig): Flow<ImuSample> =
        callbackFlow {
            // 중력이 포함된 원래 가속도. TYPE_LINEAR_ACCELERATION 이 아니다. (A 1.6.2)
            val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
            if (sensor == null) {
                Log.w(TAG, "Accelerometer not available")
                close()
                return@callbackFlow
            }

            val thread = HandlerThread("widyu-imu").apply { start() }
            val listener =
                object : SensorEventListener {
                    override fun onSensorChanged(event: SensorEvent) {
                        val type =
                            if (event.sensor.type == Sensor.TYPE_GYROSCOPE) ImuSample.Type.GYRO else ImuSample.Type.ACC
                        trySendBlocking(
                            ImuSample(
                                type = type,
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
                    MICROS_PER_SECOND,
                    Handler(thread.looper),
                )
            if (!registered) {
                Log.w(TAG, "Failed to register accelerometer listener")
                thread.quitSafely()
                close()
                return@callbackFlow
            }

            // 자이로는 끄는 설정이 없다 — 충격 직전 2초는 상시 수집으로만 확보된다. (A 1.6.4)
            val gyroscope = sensorManager.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
            if (gyroscope == null) {
                Log.w(TAG, "Gyroscope not available")
            } else if (!sensorManager.registerListener(
                    listener,
                    gyroscope,
                    MICROS_PER_SECOND / config.accHz,
                    MICROS_PER_SECOND,
                    Handler(thread.looper),
                )
            ) {
                // 가속도는 계속 흐르게 둔다. 자이로만 빠진 것은 flow 를 끝낼 이유가 아니다.
                Log.w(TAG, "Failed to register gyroscope listener")
            }

            awaitClose {
                sensorManager.unregisterListener(listener)
                thread.quitSafely()
            }
        }

    private companion object {
        const val TAG = "Widyu"

        /** maxReportLatencyUs 로도 쓴다 — 센서 FIFO 가 1초치를 모으는 동안 CPU 가 잔다. */
        const val MICROS_PER_SECOND = 1_000_000
    }
}
