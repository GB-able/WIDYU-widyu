package com.example.widyu

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private val heartRateChannelManager: HeartRateChannelManager by lazy { (application as App).heartRateChannelManager }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        heartRateChannelManager.initialize(flutterEngine.dartExecutor.binaryMessenger)
    }
}
