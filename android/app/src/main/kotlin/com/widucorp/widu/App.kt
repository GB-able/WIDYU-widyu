package com.widucorp.widu

import android.app.Application

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        SafetyCheckService.createChannels(this)
    }
}
