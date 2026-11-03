package com.widucorp.widu

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var safetyChannel: MethodChannel? = null
    private var pendingIncidentId: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "widyu/permissions")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getAndroidSdkInt" -> result.success(Build.VERSION.SDK_INT)
                    else -> result.notImplemented()
                }
            }
        safetyChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.widucorp.widu/safety_push")
            .apply {
                setMethodCallHandler { call, result ->
                    when (call.method) {
                        "consumePendingIncident" -> {
                            result.success(pendingIncidentId)
                            pendingIncidentId = null
                        }
                        "stopAlarm" -> {
                            SafetyCheckService.stop(call.argument<String>("incidentId"))
                            result.success(null)
                        }
                        "releaseLockScreen" -> {
                            setLockScreenVisible(false)
                            result.success(null)
                        }
                        else -> result.notImplemented()
                    }
                }
            }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleSafetyCheckIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleSafetyCheckIntent(intent)
    }

    private fun handleSafetyCheckIntent(intent: Intent?) {
        val incidentId = intent?.getStringExtra(SafetyCheckService.EXTRA_INCIDENT_ID)
        if (incidentId.isNullOrEmpty()) return
        intent.removeExtra(SafetyCheckService.EXTRA_INCIDENT_ID)
        pendingIncidentId = incidentId
        setLockScreenVisible(true)
        SafetyCheckService.onScreenShown()
        safetyChannel?.invokeMethod("onIncident", null)
    }

    private fun setLockScreenVisible(visible: Boolean) {
        if (Build.VERSION.SDK_INT >= 27) {
            setShowWhenLocked(visible)
            setTurnScreenOn(visible)
        } else {
            val flags = WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            if (visible) window.addFlags(flags) else window.clearFlags(flags)
        }
        if (visible) {
            window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        } else {
            window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        }
    }

    companion object {
        fun safetyCheckIntent(context: Context, incidentId: String): Intent =
            Intent(context, MainActivity::class.java)
                .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                .putExtra(SafetyCheckService.EXTRA_INCIDENT_ID, incidentId)
    }
}
