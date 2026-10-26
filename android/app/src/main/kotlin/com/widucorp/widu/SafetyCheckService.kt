package com.widucorp.widu

import android.app.KeyguardManager
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.ToneGenerator
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.provider.Settings
import android.util.Log

class SafetyCheckService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private val timeout = Runnable { stopSelf() }
    private val cancelFcm = Runnable { cancelFcmNotifications() }
    private var tone: ToneGenerator? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var focus: AudioFocusRequest? = null
    private var incidentId: String? = null

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        current = this
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val id = intent?.getStringExtra(EXTRA_INCIDENT_ID)
        val screen = MainActivity.safetyCheckIntent(this, id.orEmpty())
        val content = PendingIntent.getActivity(
            this,
            0,
            screen,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val inUse = isInUse()
        val canOverlay = Settings.canDrawOverlays(this)
        val notification = notification(content, fullScreen = !(inUse && canOverlay))
        if (Build.VERSION.SDK_INT >= 29) {
            startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
        if (id == null) {
            stopSelf(); return START_NOT_STICKY
        }
        if (!inUse) wakeScreen()
        if (canOverlay) {
            try {
                startActivity(screen)
            } catch (e: Exception) {
                Log.w(TAG, "Safety check screen launch failed", e)
                getSystemService(NotificationManager::class.java)
                    .notify(NOTIFICATION_ID, notification(content, fullScreen = true))
            }
        }
        cancelFcmNotifications()
        handler.removeCallbacks(cancelFcm)
        handler.postDelayed(cancelFcm, FCM_RECHECK_DELAY_MS)
        handler.removeCallbacks(timeout)
        handler.postDelayed(timeout, TIMEOUT_MS)
        if (incidentId != id) {
            incidentId = id
            startAudio()
        }
        return START_NOT_STICKY
    }

    private fun isInUse(): Boolean =
        getSystemService(PowerManager::class.java).isInteractive &&
                !getSystemService(KeyguardManager::class.java).isKeyguardLocked

    @Suppress("DEPRECATION")
    private fun wakeScreen() {
        getSystemService(PowerManager::class.java)
            .newWakeLock(
                PowerManager.SCREEN_BRIGHT_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
                "widyu:safety-check-screen"
            )
            .acquire(SCREEN_WAKE_MS)
    }

    private fun notification(content: PendingIntent, fullScreen: Boolean): Notification =
        Notification.Builder(this, if (fullScreen) ALARM_CHANNEL else SILENT_CHANNEL)
            .setSmallIcon(applicationInfo.icon)
            .setContentTitle(TITLE)
            .setContentText(BODY)
            .setCategory(Notification.CATEGORY_ALARM)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setOngoing(true)
            .setContentIntent(content)
            .apply { if (fullScreen) setFullScreenIntent(content, true) }
            .build()

    private fun cancelFcmNotifications() {
        val manager = getSystemService(NotificationManager::class.java)
        manager.activeNotifications
            .filter { it.tag?.startsWith(FCM_TAG_PREFIX) == true && it.notification.channelId == SAFETY_CHANNEL }
            .forEach { manager.cancel(it.tag, it.id) }
    }

    private fun startAudio() {
        releaseAudio()
        val attributes = AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION).build()
        val audio = getSystemService(AudioManager::class.java)
        focus = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
            .setAudioAttributes(attributes).build().also { audio.requestAudioFocus(it) }
        wakeLock = getSystemService(PowerManager::class.java)
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "widyu:safety-check")
            .apply { acquire(TIMEOUT_MS) }
        try {
            tone = ToneGenerator(AudioManager.STREAM_ALARM, ToneGenerator.MAX_VOLUME).apply {
                startTone(ToneGenerator.TONE_CDMA_EMERGENCY_RINGBACK)
            }
        } catch (e: Exception) {
            Log.w(TAG, "Safety check alarm playback failed", e)
        }
        getSystemService(Vibrator::class.java)
            .vibrate(VibrationEffect.createWaveform(longArrayOf(0, 600, 500), 0))
    }

    private fun releaseAudio() {
        tone?.release(); tone = null
        getSystemService(Vibrator::class.java).cancel()
        focus?.let { getSystemService(AudioManager::class.java).abandonAudioFocusRequest(it) }
        focus = null
        wakeLock?.let { if (it.isHeld) it.release() }
        wakeLock = null
    }

    override fun onDestroy() {
        handler.removeCallbacksAndMessages(null)
        releaseAudio()
        stopForeground(STOP_FOREGROUND_REMOVE)
        if (current === this) current = null
        super.onDestroy()
    }

    companion object {
        const val PUSH_TYPE = "EMERGENCY_CONFIRM_REQUEST"
        const val EXTRA_INCIDENT_ID = "safetyIncidentId"
        private const val TAG = "SafetyCheckService"
        private const val SAFETY_CHANNEL = "widyu_safety"
        private const val ALARM_CHANNEL = "widyu_safety_check_v1"
        private const val SILENT_CHANNEL = "widyu_safety_check_silent_v1"
        private const val FCM_TAG_PREFIX = "FCM-Notification"
        private const val NOTIFICATION_ID = 48191
        private const val TIMEOUT_MS = 90_000L
        private const val FCM_RECHECK_DELAY_MS = 1_500L
        private const val SCREEN_WAKE_MS = 5_000L
        private const val TITLE = "평소와 다른 심박이 감지됐어요."
        private const val BODY = "괜찮으시면 취소를 눌러주세요. 시간 안에 누르지 않으면 보호자에게 알려드려요."

        private var current: SafetyCheckService? = null

        fun stop(incidentId: String?) {
            val service = current ?: return
            if (incidentId == null || incidentId == service.incidentId) service.stopSelf()
        }

        fun createChannels(context: Context) {
            val manager = context.getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(
                NotificationChannel(SAFETY_CHANNEL, "안전 알림", NotificationManager.IMPORTANCE_HIGH).apply {
                    description = "평소와 다른 심박 등 본인 확인이 필요한 알림"
                    lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                }
            )
            manager.createNotificationChannel(
                NotificationChannel(ALARM_CHANNEL, "안전 알림 알람", NotificationManager.IMPORTANCE_HIGH).apply {
                    description = "본인 확인 화면이 떠 있는 동안 울리는 알람"
                    setSound(null, null)
                    enableVibration(false)
                    lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                }
            )
            manager.createNotificationChannel(
                NotificationChannel(SILENT_CHANNEL, "안전 확인 진행 중", NotificationManager.IMPORTANCE_LOW).apply {
                    description = "본인 확인 화면이 떠 있는 동안 표시되는 알림"
                    lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                }
            )
        }
    }
}
