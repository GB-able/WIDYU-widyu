package com.widucorp.widu.data.source

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.database.ContentObserver
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.BatteryManager
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import androidx.core.content.ContextCompat
import com.google.android.gms.wearable.NodeClient
import com.widucorp.widu.data.util.awaitResult
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOf
import java.util.concurrent.TimeUnit
import javax.inject.Inject

class DeviceStateLocalDataSourceImpl @Inject constructor(
    @ApplicationContext private val context: Context,
    private val sensorManager: SensorManager,
    private val nodeClient: NodeClient,
) : DeviceStateLocalDataSource {
    private val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
    private val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager

    override fun charging(): Flow<Boolean> =
        broadcastState(Intent.ACTION_POWER_CONNECTED, Intent.ACTION_POWER_DISCONNECTED) { action ->
            when (action) {
                Intent.ACTION_POWER_CONNECTED -> true
                Intent.ACTION_POWER_DISCONNECTED -> false
                else -> batteryManager.isCharging
            }
        }

    override fun powerSave(): Flow<Boolean> =
        broadcastState(PowerManager.ACTION_POWER_SAVE_MODE_CHANGED) { powerManager.isPowerSaveMode }

    override fun screenOn(): Flow<Boolean> =
        broadcastState(Intent.ACTION_SCREEN_ON, Intent.ACTION_SCREEN_OFF) { action ->
            when (action) {
                Intent.ACTION_SCREEN_ON -> true
                Intent.ACTION_SCREEN_OFF -> false
                else -> powerManager.isInteractive
            }
        }

    override fun brightness(): Flow<Int> =
        callbackFlow {
            val resolver = context.contentResolver
            fun read() = Settings.System.getInt(resolver, Settings.System.SCREEN_BRIGHTNESS, -1)
            val observer =
                object : ContentObserver(Handler(Looper.getMainLooper())) {
                    override fun onChange(selfChange: Boolean) {
                        trySend(read())
                    }
                }
            trySend(read())
            resolver.registerContentObserver(Settings.System.getUriFor(Settings.System.SCREEN_BRIGHTNESS), false, observer)
            awaitClose { resolver.unregisterContentObserver(observer) }
        }

    override fun offBodyRaw(): Flow<Int?> {
        // wake-up 변형만 두는 기기와 아닌 기기가 있어 둘 다 찾는다.
        val sensor =
            sensorManager.getDefaultSensor(Sensor.TYPE_LOW_LATENCY_OFFBODY_DETECT, true)
                ?: sensorManager.getDefaultSensor(Sensor.TYPE_LOW_LATENCY_OFFBODY_DETECT)
                ?: return flowOf(null)
        return callbackFlow {
            val listener =
                object : SensorEventListener {
                    override fun onSensorChanged(event: SensorEvent) {
                        trySend(event.values[0].toInt())
                    }

                    override fun onAccuracyChanged(
                        sensor: Sensor,
                        accuracy: Int,
                    ) = Unit
                }
            // on-change 센서라 등록하면 현재 값이 한 번 온다.
            sensorManager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_NORMAL)
            awaitClose { sensorManager.unregisterListener(listener) }
        }
    }

    // ponytail: 30초 폴링이라 끊김 시각 오차가 최대 30초. 정밀도가 필요하면 CapabilityClient 리스너로 바꾼다(폰 앱에 capability 선언 필요).
    override fun phoneConnected(): Flow<Boolean> =
        flow {
            while (true) {
                try {
                    emit(nodeClient.connectedNodes.awaitResult().isNotEmpty())
                } catch (exception: CancellationException) {
                    throw exception
                } catch (exception: Exception) {
                    Log.w(TAG, "Failed to read connected nodes", exception)
                }
                delay(PHONE_POLL_MS)
            }
        }

    /** 시스템 방송은 동적 등록만 받는다. [read] 는 시작 시 null 로 한 번, 이후 받은 action 으로 불린다. */
    private fun <T> broadcastState(
        vararg actions: String,
        read: (action: String?) -> T,
    ): Flow<T> =
        callbackFlow {
            val receiver =
                object : BroadcastReceiver() {
                    override fun onReceive(
                        context: Context,
                        intent: Intent,
                    ) {
                        trySend(read(intent.action))
                    }
                }
            trySend(read(null))
            val filter = IntentFilter().apply { actions.forEach(::addAction) }
            ContextCompat.registerReceiver(context, receiver, filter, ContextCompat.RECEIVER_NOT_EXPORTED)
            awaitClose { context.unregisterReceiver(receiver) }
        }

    private companion object {
        const val TAG = "Widyu"
        val PHONE_POLL_MS = TimeUnit.SECONDS.toMillis(30)
    }
}
