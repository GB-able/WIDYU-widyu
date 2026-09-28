package com.gbable.widu.data.service

import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.ServiceCompat
import com.gbable.widu.BuildConfig
import com.gbable.widu.data.model.MeasureResult
import com.gbable.widu.data.repository.FallDetectionRepository
import com.gbable.widu.data.repository.HeartRateRepository
import com.gbable.widu.data.repository.ImuRepository
import com.gbable.widu.presentation.util.WidyuNotificationManager
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import javax.inject.Inject

@AndroidEntryPoint
class HeartRateForegroundService : Service() {
    @Inject
    lateinit var repository: HeartRateRepository

    @Inject
    lateinit var fallDetectionRepository: FallDetectionRepository

    @Inject
    lateinit var imuRepository: ImuRepository

    @Inject
    lateinit var notificationManager: WidyuNotificationManager

    private val serviceScope: CoroutineScope = CoroutineScope(Dispatchers.Default + SupervisorJob())
    private var isRunning: Boolean = false
    private var job: Job? = null
    private var imuJob: Job? = null

    override fun onStartCommand(
        intent: Intent?,
        flags: Int,
        startId: Int,
    ): Int {
        super.onStartCommand(intent, flags, startId)

        if (intent?.action == ACTION_RESTART_SESSION) {
            if (!isRunning) startService()
            serviceScope.launch { repository.restartSession() }
            return START_STICKY
        }

        if (isRunning) return START_STICKY
        startService()
        startMeasurement()
        return START_STICKY
    }

    private fun startService() {
        isRunning = true
        serviceScope.launch { fallDetectionRepository.startDetection() }
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
                    when (result) {
                        is MeasureResult.Availability -> Unit
                        is MeasureResult.HeartRate -> Log.d("Widyu", "Service Heart Rate: ${result.value}")
                        is MeasureResult.SessionSuperseded -> {
                            notificationManager.showRestartNotification()
                        }
                    }
                }.launchIn(serviceScope)

        imuJob =
            imuRepository
                .batches()
                .catch { Log.e("Widyu", "IMU collection error", it) }
                .onEach { batch ->
                    if (BuildConfig.DEBUG) Log.d("Widyu", "IMU batch seq=${batch.seq} n=${batch.acc?.values?.size}")
                }.launchIn(serviceScope)
    }

    override fun onDestroy() {
        job?.cancel()
        job = null
        imuJob?.cancel()
        imuJob = null
        isRunning = false
        runBlocking { fallDetectionRepository.stopDetection() }
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    companion object {
        private const val ACTION_RESTART_SESSION = "com.gbable.widu.ACTION_RESTART_SESSION"

        fun newIntent(context: Context): Intent = Intent(context, HeartRateForegroundService::class.java)

        fun restartSessionIntent(context: Context): Intent =
            newIntent(context).apply { action = ACTION_RESTART_SESSION }
    }
}
