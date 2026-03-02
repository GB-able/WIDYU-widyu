package com.example.widyu.presentation.util

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
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
    private val requiredPermissions: Array<String> by lazy {
        buildList {
            add(Manifest.permission.BODY_SENSORS)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                add(Manifest.permission.BODY_SENSORS_BACKGROUND)
            }
        }.toTypedArray()
    }

    fun hasBackgroundPermission(context: Context): Boolean =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.BODY_SENSORS_BACKGROUND,
            ) == PackageManager.PERMISSION_GRANTED
        } else {
            true
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
): ManagedActivityResultLauncher<String, Boolean> {
    val coroutineScope = rememberCoroutineScope()
    val context = LocalContext.current

    return rememberLauncherForActivityResult(ActivityResultContracts.RequestPermission()) { isGranted ->
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
