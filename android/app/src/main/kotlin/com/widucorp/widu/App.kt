package com.widucorp.widu

import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationManager

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        SafetyCheckService.createChannels(this)
        getSystemService(NotificationManager::class.java).createNotificationChannels(
            listOf(
                NotificationChannel("widyu_default_channel", "위듀 알림", NotificationManager.IMPORTANCE_MAX),
                NotificationChannel("widyu_quiet_channel", "조용한 알림", NotificationManager.IMPORTANCE_LOW),
            )
        )
    }
}
