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
                return@buildList
            }
            add(Manifest.permission.BODY_SENSORS)
        }.toTypedArray()
    }

    val backgroundPermission: String? by lazy {
        when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.BAKLAVA -> HealthPermissions.READ_HEALTH_DATA_IN_BACKGROUND
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU -> Manifest.permission.BODY_SENSORS_BACKGROUND
            else -> null
        }
    }

    // Android 16(BAKLAVA)+ 부터 백그라운드 헬스 권한은 포그라운드 승인 이후 별도의 런타임 프롬프트로 요청할 수 있다.
    // Android 15 이하의 `BODY_SENSORS_BACKGROUND`(항상 허용)는 런타임 프롬프트로 받을 수 없어 설정 화면 유도가 필요하다.
    fun canRequestBackgroundAtRuntime(): Boolean = Build.VERSION.SDK_INT >= Build.VERSION_CODES.BAKLAVA

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

    fun hasRuntimePermissions(context: Context): Boolean =
        requiredPermissions.all { permission ->
            ContextCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED
        }

    fun hasAllPermissions(context: Context): Boolean = hasRuntimePermissions(context) && hasBackgroundPermission(context)

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

    // Android 16(BAKLAVA)+ 에서 백그라운드 헬스 권한이 영구 거부되어 더 이상 런타임 프롬프트를 띄울 수 없는 상태인지 판단한다.
    // 이 경우 사용자를 설정 화면으로 유도해야 한다.
    fun isBackgroundPermanentlyDenied(activity: Activity): Boolean {
        val permission = backgroundPermission ?: return false
        if (!canRequestBackgroundAtRuntime()) return false
        return ContextCompat.checkSelfPermission(activity, permission) != PackageManager.PERMISSION_GRANTED &&
            !activity.shouldShowRequestPermissionRationale(permission)
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
    onDenied: () -> Unit = {},
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

            isPermanentlyDenied(activity) -> {
                onRequireRuntimePermission()
            }

            else -> {
                onDenied()
            }
        }
    }
}

@Composable
fun rememberBackgroundPermissionLauncher(
    onGranted: () -> Unit,
    onDenied: () -> Unit,
): ManagedActivityResultLauncher<Array<String>, Map<String, Boolean>> {
    val context = LocalContext.current

    return rememberLauncherForActivityResult(ActivityResultContracts.RequestMultiplePermissions()) {
        if (hasBackgroundPermission(context)) {
            onGranted()
        } else {
            onDenied()
        }
    }
}
