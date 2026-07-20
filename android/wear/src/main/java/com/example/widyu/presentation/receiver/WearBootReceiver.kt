package com.example.widyu.presentation.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.example.widyu.data.service.HeartRateForegroundService
import com.example.widyu.presentation.util.PermissionManager

class WearBootReceiver : BroadcastReceiver() {
    override fun onReceive(
        context: Context,
        intent: Intent,
    ) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED && PermissionManager.hasAllPermissions(context)) {
            val serviceIntent = HeartRateForegroundService.newIntent(context)
            context.startForegroundService(serviceIntent)
        }
    }
}
