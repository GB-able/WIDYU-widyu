package com.example.widyu.data.service

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.ServiceCompat
import com.example.widyu.data.model.MeasureResult
import com.example.widyu.data.repository.HeartRateRepository
import com.example.widyu.presentation.util.WidyuNotificationManager
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject

@AndroidEntryPoint
class HeartRateForegroundService : Service() {
    @Inject
    lateinit var repository: HeartRateRepository

    @Inject
    lateinit var notificationManager: WidyuNotificationManager

    private val serviceScope: CoroutineScope = CoroutineScope(Dispatchers.Default + SupervisorJob())
    private var isRunning: Boolean = false
    private var job: Job? = null

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int,
    ): Int {
        super.onStartCommand(intent, flags, startId)
        if (isRunning) return START_STICKY

        startService()
        startMeasurement()
        return START_STICKY
    }

    private fun startService() {
        isRunning = true
        notificationManager.createChannel()
        ServiceCompat.startForeground(
            this,
            WidyuNotificationManager.NOTIFICATION_ID,
            notificationManager.buildNotification(),
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                ServiceInfo.FOREGROUND_SERVICE_TYPE_HEALTH
            } else {
                0
            },
        )
    }

    private fun startMeasurement() {
        if (job?.isActive == true) return

        job =
            repository
                .getHeartRate()
                .catch { Log.e("Widyu", "Service Measurement Error", it) }
                .onEach { result ->
                    if (result is MeasureResult.HeartRate) {
                        Log.d("Widyu", "Service Heart Rate: ${result.value}")
                    }
                }.launchIn(serviceScope)
    }

    override fun onDestroy() {
        job?.cancel()
        job = null
        isRunning = false
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    companion object {
        fun newIntent(context: Context): Intent = Intent(context, HeartRateForegroundService::class.java)
    }
}
