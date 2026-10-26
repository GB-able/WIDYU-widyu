package com.widucorp.widu

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class SafetyPushReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.getStringExtra("type") != SafetyCheckService.PUSH_TYPE) return
        val incidentId = intent.getStringExtra("entityId") ?: return
        try {
            context.startForegroundService(
                Intent(context, SafetyCheckService::class.java)
                    .putExtra(SafetyCheckService.EXTRA_INCIDENT_ID, incidentId)
            )
        } catch (e: Exception) {
            Log.w(TAG, "Safety check alarm start failed", e)
        }
    }

    private companion object {
        const val TAG = "SafetyPushReceiver"
    }
}
