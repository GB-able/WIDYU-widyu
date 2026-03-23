package com.example.widyu.presentation.util

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import androidx.core.app.NotificationCompat
import androidx.wear.ongoing.OngoingActivity
import com.example.widyu.R
import com.example.widyu.presentation.MainActivity
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
        val channel =
            NotificationChannel(
                NOTIFICATION_CHANNEL,
                NOTIFICATION_CHANNEL_DISPLAY,
                NotificationManager.IMPORTANCE_DEFAULT,
            )
        notificationManager.createNotificationChannel(channel)
    }

    // 알림 아이콘 추가 필요
    fun buildNotification(): Notification {
        val notificationIntent = MainActivity.Companion.newIntent(context)
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
                .setContentIntent(pendingIntent)
                .setCategory(NotificationCompat.CATEGORY_WORKOUT)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)

        val ongoingActivity =
            OngoingActivity
                .Builder(context, NOTIFICATION_ID, notificationBuilder)
                .setTouchIntent(pendingIntent)
                .setStaticIcon(R.drawable.ic_launcher_background)
                .build()

        ongoingActivity.apply(context)
        return notificationBuilder.build()
    }

    companion object {
        const val NOTIFICATION_ID = 1
        private const val NOTIFICATION_CHANNEL = "com.example.widyu.HEART_RATE"
        private const val NOTIFICATION_CHANNEL_DISPLAY = "Widyu Heart Rate"
        private const val NOTIFICATION_TITLE = "위듀"
        private const val NOTIFICATION_TEXT = "위듀에서 심박수를 측정하고 있습니다."
    }
}
