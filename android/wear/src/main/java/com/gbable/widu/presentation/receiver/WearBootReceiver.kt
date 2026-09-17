package com.gbable.widu.presentation.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.gbable.widu.data.service.HeartRateForegroundService
import com.gbable.widu.presentation.util.PermissionManager

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
