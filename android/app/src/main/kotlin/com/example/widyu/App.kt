package com.example.widyu

import android.app.Application

class App : Application() {
    val heartRateChannelManager: HeartRateChannelManager by lazy { HeartRateChannelManager(this) }
}
