package com.widucorp.widu.presentation.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.widucorp.widu.data.service.HeartRateForegroundService
import com.widucorp.widu.presentation.util.PermissionManager

class WearBootReceiver : BroadcastReceiver() {
    override fun onReceive(
        context: Context,
        intent: Intent,
    ) {
        // 앱 업데이트는 프로세스를 종료해 측정 서비스도 함께 죽으므로, 재부팅과 같이 다시 시작한다.
        val isRestartTrigger =
            intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == Intent.ACTION_MY_PACKAGE_REPLACED
        if (isRestartTrigger && PermissionManager.hasAllPermissions(context)) {
            val serviceIntent = HeartRateForegroundService.newIntent(context)
            context.startForegroundService(serviceIntent)
        }
    }
}
