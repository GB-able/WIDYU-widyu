package com.widucorp.widu.medication_alarm

import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.core.app.NotificationCompat

class AlarmPlaybackService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private var player: MediaPlayer? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var focus: AudioFocusRequest? = null
    private var groupId: String? = null
    override fun onBind(intent: Intent?): IBinder? = null
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val id = intent?.getStringExtra("groupId")
        val group =
            synchronized(AlarmStore.lock) { AlarmStore.read(this).optJSONObject("activeGroup") }
        if (id == null || group?.optString("groupId") != id) {
            stopSelf(); return START_NOT_STICKY
        }
        val scheduler = AlarmScheduler(this)
        val stop = PendingIntent.getBroadcast(
            this,
            2,
            Intent(this, AlarmReceiver::class.java)
                .setAction("com.widucorp.widu.medication.STOP")
                .setData(android.net.Uri.parse("widyu-alarm://stop/$id"))
                .putExtra("groupId", id),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val dose = AlarmStore.objects(group.getJSONArray("occurrences"))
            .sumOf { it.getDouble("doseCount") }
        val notification = NotificationCompat.Builder(this, AlarmScheduler.CHANNEL)
            .setSmallIcon(applicationInfo.icon).setContentTitle("${doseLabel(dose)}정 복용하실 시간이에요!")
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC).setOngoing(true)
            .setContentIntent(scheduler.show(group, true))
            .addAction(0, "인증하러 가기", scheduler.show(group, true)).addAction(0, "중단", stop)
            .setFullScreenIntent(scheduler.show(group), true).build()
        startForeground(48190, notification)
        if (groupId == id) return START_NOT_STICKY
        releaseAudio()
        groupId = id
        val attributes = AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ALARM)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION).build()
        val audio = getSystemService(AudioManager::class.java)
        focus = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
            .setAudioAttributes(attributes).setOnAudioFocusChangeListener { change ->
                if (change == AudioManager.AUDIOFOCUS_LOSS) stopSelf()
            }.build().also { audio.requestAudioFocus(it) }
        wakeLock = getSystemService(PowerManager::class.java).newWakeLock(
            PowerManager.PARTIAL_WAKE_LOCK,
            "widyu:medication-alarm"
        ).apply { acquire(5 * 60 * 1000L) }
        try {
            player = MediaPlayer().apply {
                setAudioAttributes(attributes)
                setDataSource(
                    this@AlarmPlaybackService,
                    RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
                        ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                )
                isLooping = true
                prepare()
                start()
            }
            getSystemService(Vibrator::class.java).vibrate(
                VibrationEffect.createWaveform(
                    longArrayOf(0, 600, 500),
                    0
                )
            )
        } catch (e: Exception) {
            synchronized(AlarmStore.lock) {
                val state = AlarmStore.read(this).put("playbackError", e.javaClass.simpleName)
                AlarmStore.write(this, state)
            }
        }
        handler.removeCallbacksAndMessages(null)
        handler.postDelayed({ MedicationAlarmPlugin.stop(this, id) }, 5 * 60 * 1000L)
        return START_NOT_STICKY
    }

    private fun releaseAudio() {
        player?.release(); player = null
        getSystemService(Vibrator::class.java).cancel()
        focus?.let { getSystemService(AudioManager::class.java).abandonAudioFocusRequest(it) }; focus =
            null
        wakeLock?.let { if (it.isHeld) it.release() }; wakeLock = null
    }

    override fun onDestroy() {
        handler.removeCallbacksAndMessages(null)
        releaseAudio()
        stopForeground(STOP_FOREGROUND_REMOVE)
        groupId?.let { id ->
            synchronized(AlarmStore.lock) {
                val state = AlarmStore.read(this)
                if (state.optJSONObject("activeGroup")?.optString("groupId") == id) {
                    state.remove("activeGroup"); AlarmStore.write(this, state)
                }
            }
        }
        MedicationAlarmPlugin.emit()
        super.onDestroy()
    }

    companion object {
        internal fun doseLabel(dose: Double) =
            if (dose % 1.0 == 0.0) dose.toInt().toString() else String.format(
                java.util.Locale.US,
                "%.1f",
                dose
            )
    }
}
