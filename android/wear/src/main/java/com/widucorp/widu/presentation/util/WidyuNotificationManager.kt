package com.widucorp.widu.presentation.util

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import androidx.core.app.NotificationCompat
import androidx.wear.ongoing.OngoingActivity
import com.widucorp.widu.R
import com.widucorp.widu.presentation.MainActivity
import dagger.hilt.android.qualifiers.ApplicationContext
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class WidyuNotificationManager @Inject constructor(
    @ApplicationContext private val context: Context,
) {
    private val notificationManager: NotificationManager =
        context.getSystemService(
            NotificationManager::class.java,
        )

    fun createChannel() {
        notificationManager.createNotificationChannel(
            NotificationChannel(
                NOTIFICATION_CHANNEL,
                NOTIFICATION_CHANNEL_DISPLAY,
                NotificationManager.IMPORTANCE_DEFAULT,
            ),
        )
        notificationManager.createNotificationChannel(
            NotificationChannel(
                RESTART_NOTIFICATION_CHANNEL,
                RESTART_NOTIFICATION_CHANNEL_DISPLAY,
                NotificationManager.IMPORTANCE_HIGH,
            ),
        )
    }

    fun buildNotification(): Notification {
        val notificationIntent = MainActivity.newIntent(context)
        val pendingIntent =
            PendingIntent.getActivity(
                context,
                0,
                notificationIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
            )

        val notificationBuilder =
            NotificationCompat
                .Builder(context, NOTIFICATION_CHANNEL)
                .setContentTitle(NOTIFICATION_TITLE)
                .setContentText(NOTIFICATION_TEXT)
                .setSmallIcon(R.drawable.ic_stat_widyu)
                .setContentIntent(pendingIntent)
                .setCategory(NotificationCompat.CATEGORY_WORKOUT)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)

        val ongoingActivity =
            OngoingActivity
                .Builder(context, NOTIFICATION_ID, notificationBuilder)
                .setTouchIntent(pendingIntent)
                .setStaticIcon(R.drawable.ic_stat_widyu)
                .build()

        ongoingActivity.apply(context)
        return notificationBuilder.build()
    }

    fun showRestartNotification() {
        val intent = MainActivity.newRestartIntent(context)
        val pendingIntent =
            PendingIntent.getActivity(
                context,
                RESTART_NOTIFICATION_ID,
                intent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
            )

        val notification =
            NotificationCompat
                .Builder(context, RESTART_NOTIFICATION_CHANNEL)
                .setContentTitle(RESTART_NOTIFICATION_TITLE)
                .setContentText(RESTART_NOTIFICATION_TEXT)
                .setSmallIcon(R.drawable.ic_stat_widyu)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setCategory(NotificationCompat.CATEGORY_WORKOUT)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .build()

        notificationManager.notify(RESTART_NOTIFICATION_ID, notification)
    }

    companion object {
        const val NOTIFICATION_ID = 1
        const val RESTART_NOTIFICATION_ID = 2
        private const val NOTIFICATION_CHANNEL = "com.widucorp.widu.HEART_RATE"
        private const val NOTIFICATION_CHANNEL_DISPLAY = "Widyu Heart Rate"
        private const val RESTART_NOTIFICATION_CHANNEL = "com.widucorp.widu.HEART_RATE_RESTART"
        private const val RESTART_NOTIFICATION_CHANNEL_DISPLAY = "Widyu Heart Rate Alert"
        private const val NOTIFICATION_TITLE = "위듀"
        private const val NOTIFICATION_TEXT = "위듀에서 심박수를 측정하고 있습니다."
        private const val RESTART_NOTIFICATION_TITLE = "심박수 측정이 중단되었습니다"
        private const val RESTART_NOTIFICATION_TEXT = "다른 운동 앱이 실행되어 측정이 중단되었습니다. 탭하여 다시 시작하세요."
    }
}
