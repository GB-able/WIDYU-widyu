package com.example.widyu.presentation.util

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.health.connect.HealthPermissions
import android.os.Build
import android.provider.Settings
import androidx.activity.compose.ManagedActivityResultLauncher
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.platform.LocalContext
import androidx.core.content.ContextCompat
import androidx.core.net.toUri
import com.example.widyu.presentation.util.PermissionManager.hasBackgroundPermission
import com.example.widyu.presentation.util.PermissionManager.isPermanentlyDenied

object PermissionManager {
    val requiredPermissions: Array<String> by lazy {
        buildList {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                add(Manifest.permission.POST_NOTIFICATIONS)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.BAKLAVA) {
                add(HealthPermissions.READ_HEART_RATE)
                add(HealthPermissions.READ_HEALTH_DATA_IN_BACKGROUND)
                return@buildList
            }
            add(Manifest.permission.BODY_SENSORS)
        }.toTypedArray()
    }

    fun hasBackgroundPermission(context: Context): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.BAKLAVA) {
            return ContextCompat.checkSelfPermission(
                context,
                HealthPermissions.READ_HEALTH_DATA_IN_BACKGROUND,
            ) == PackageManager.PERMISSION_GRANTED
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            return ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.BODY_SENSORS_BACKGROUND,
            ) == PackageManager.PERMISSION_GRANTED
        }
        return true
    }

    fun isPermanentlyDenied(activity: Activity): Boolean =
        requiredPermissions.any { permission ->
            ContextCompat.checkSelfPermission(
                activity,
                permission,
            ) != PackageManager.PERMISSION_GRANTED &&
                !activity.shouldShowRequestPermissionRationale(
                    permission,
                )
        }

    fun openAppSettings(context: Context) {
        val intent =
            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                data = "package:${context.packageName}".toUri()
            }
        context.startActivity(intent)
    }
}

@Composable
fun rememberPermissionLauncher(
    activity: Activity,
    onGranted: () -> Unit,
    onRequireRuntimePermission: () -> Unit,
    onRequireBackgroundPermission: () -> Unit,
): ManagedActivityResultLauncher<Array<String>, Map<String, Boolean>> {
    val coroutineScope = rememberCoroutineScope()
    val context = LocalContext.current

    return rememberLauncherForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) { permissions ->
        val isGranted = permissions.all { it.value }
        when {
            isGranted -> {
                if (hasBackgroundPermission(context)) {
                    onGranted()
                } else {
                    onRequireBackgroundPermission()
                }
            }

            isPermanentlyDenied(activity) -> onRequireRuntimePermission()

            else -> {
            }
        }
    }
}
