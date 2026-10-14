package com.gbable.widu.presentation.component

import android.content.res.Configuration
import androidx.activity.compose.LocalActivity
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.FirstBaseline
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.compose.LifecycleEventEffect
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.wear.compose.material.Icon
import androidx.wear.compose.material.Text
import com.gbable.widu.data.service.HeartRateForegroundService
import com.gbable.widu.presentation.MainViewModel
import com.gbable.widu.presentation.PermissionState
import com.gbable.widu.presentation.PermissionViewModel
import com.gbable.widu.presentation.UiState
import com.gbable.widu.presentation.model.UiModel
import com.gbable.widu.presentation.model.UiModel.Companion.toUiModel
import com.gbable.widu.presentation.theme.WidyuTheme
import com.gbable.widu.presentation.util.PermissionManager.backgroundPermission
import com.gbable.widu.presentation.util.PermissionManager.canRequestBackgroundAtRuntime
import com.gbable.widu.presentation.util.PermissionManager.hasAllPermissions
import com.gbable.widu.presentation.util.PermissionManager.hasBackgroundPermission
import com.gbable.widu.presentation.util.PermissionManager.hasRuntimePermissions
import com.gbable.widu.presentation.util.PermissionManager.isBackgroundPermanentlyDenied
import com.gbable.widu.presentation.util.PermissionManager.isPermanentlyDenied
import com.gbable.widu.presentation.util.PermissionManager.openAppSettings
import com.gbable.widu.presentation.util.PermissionManager.requiredPermissions
import com.gbable.widu.presentation.util.rememberBackgroundPermissionLauncher
import com.gbable.widu.presentation.util.rememberPermissionLauncher

@Composable
fun WidyuScreen(
    mainViewModel: MainViewModel = hiltViewModel(),
    permissionViewModel: PermissionViewModel = hiltViewModel(),
) {
    val activity = LocalActivity.current ?: return
    val context = LocalContext.current
    val uiState = mainViewModel.uiState.collectAsStateWithLifecycle().value
    val permissionState = permissionViewModel.permissionState.collectAsStateWithLifecycle().value
    val onboardingScrollState = rememberScrollState()

    var showRuntimePermissionDialog by rememberSaveable { mutableStateOf(false) }
    var showBackgroundPermissionDialog by rememberSaveable { mutableStateOf(false) }
    var isRequestingBackground by remember { mutableStateOf(false) }

    // shouldShowRationale 갱신을 기다리지 않고 즉시 설정 화면 유도로 전환하기 위한 플래그
    var isBackgroundPermissionDenied by rememberSaveable { mutableStateOf(false) }

    val onAllGranted: () -> Unit = {
        permissionViewModel.updatePermissionState(PermissionState.Granted)
        mainViewModel.checkSupported()
        context.startForegroundService(HeartRateForegroundService.newIntent(context))
    }

    val backgroundPermissionLauncher =
        rememberBackgroundPermissionLauncher(
            onGranted = {
                isRequestingBackground = false
                isBackgroundPermissionDenied = false
                onAllGranted()
            },
            onDenied = {
                isRequestingBackground = false
                isBackgroundPermissionDenied = true
                permissionViewModel.updatePermissionState(PermissionState.Restricted)
            },
        )

    val requestBackgroundPermission: () -> Unit = {
        val permission = backgroundPermission
        if (permission != null) {
            isRequestingBackground = true
            backgroundPermissionLauncher.launch(arrayOf(permission))
        } else {
            onAllGranted()
        }
    }

    val permissionLauncher =
        rememberPermissionLauncher(
            activity = activity,
            onGranted = { onAllGranted() },
            onRequireRuntimePermission = {
                permissionViewModel.updatePermissionState(PermissionState.Restricted)
                showRuntimePermissionDialog = true
            },
            onRequireBackgroundPermission = {
                if (canRequestBackgroundAtRuntime()) {
                    requestBackgroundPermission()
                } else {
                    permissionViewModel.updatePermissionState(PermissionState.Restricted)
                    showBackgroundPermissionDialog = true
                }
            },
            onDenied = { permissionViewModel.updatePermissionState(PermissionState.Restricted) },
        )

    LifecycleEventEffect(Lifecycle.Event.ON_RESUME) {
        when {
            hasAllPermissions(context) -> {
                onAllGranted()
            }

            // 백그라운드 런타임 권한 요청이 진행 중인 동안(Android 16+)에는
            // 순차 플로우가 끝날 때까지 제한 화면으로 전환하지 않고 현재 상태를 유지한다
            isRequestingBackground -> {
                Unit
            }

            permissionViewModel.isOnboardingCompleted() -> {
                permissionViewModel.updatePermissionState(PermissionState.Restricted)
            }

            else -> {
                permissionViewModel.updatePermissionState(PermissionState.Onboarding)
            }
        }
    }

    PermissionDialog(
        showDialog = showBackgroundPermissionDialog,
        onNavigateClick = {
            openAppSettings(context)
            showBackgroundPermissionDialog = false
        },
        onDismiss = { showBackgroundPermissionDialog = false },
        title = "항상 허용 권한 요청",
        description = "앱을 닫아도 심박수를 측정하려면\n심박수 데이터 접근을\n'항상 허용'으로 설정해야 해요.\n설정으로 이동해 주세요.",
    )

    PermissionDialog(
        showDialog = showRuntimePermissionDialog,
        onNavigateClick = {
            openAppSettings(context)
            showRuntimePermissionDialog = false
        },
        onDismiss = { showRuntimePermissionDialog = false },
        title = "권한 설정 필요",
        description = "심박수 측정을 위해\n알림과 심박수 권한이 필요해요.\n설정으로 이동해\n권한을 허용해 주세요.",
    )

    when (permissionState) {
        is PermissionState.Loading -> {
            WidyuLoadingIndicator()
        }

        is PermissionState.Onboarding -> {
            PermissionOnboardingScreen(
                scrollState = onboardingScrollState,
                onConfirmClick = {
                    permissionViewModel.completeOnboarding()
                    permissionViewModel.updatePermissionState(PermissionState.Loading)
                    permissionLauncher.launch(requiredPermissions)
                },
            )
        }

        is PermissionState.Restricted -> {
            val isDialogVisible = showRuntimePermissionDialog || showBackgroundPermissionDialog
            if (!isDialogVisible) {
                val needsBackgroundOnly = hasRuntimePermissions(context) && !hasBackgroundPermission(context)
                val goToSettings =
                    when {
                        !hasRuntimePermissions(context) && isPermanentlyDenied(activity) -> true
                        needsBackgroundOnly && !canRequestBackgroundAtRuntime() -> true
                        needsBackgroundOnly && (isBackgroundPermissionDenied || isBackgroundPermanentlyDenied(activity)) -> true
                        else -> false
                    }
                PermissionRestrictedScreen(
                    buttonText = if (goToSettings) "설정으로 이동" else "권한 허용",
                    onActionClick = {
                        when {
                            goToSettings -> openAppSettings(context)
                            needsBackgroundOnly -> requestBackgroundPermission()
                            else -> permissionLauncher.launch(requiredPermissions)
                        }
                    },
                )
            }
        }

        is PermissionState.Granted -> {
            WidyuScreen(uiState.toUiModel())
        }
    }
}

@Composable
private fun WidyuScreen(uiModel: UiModel?) {
    if (uiModel == null) {
        WidyuLoadingIndicator()
    } else {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center,
        ) {
            Canvas(modifier = Modifier.matchParentSize()) {
                val radius = size.width / 2f
                drawCircle(
                    brush =
                        Brush.radialGradient(
                            0.7f to uiModel.secondaryColor,
                            1.0f to uiModel.tertiaryColor,
                            center = center,
                            radius = radius,
                        ),
                )
            }

            Column(
                modifier = Modifier.fillMaxSize(),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center,
            ) {
                Text(
                    text = uiModel.text,
                    color = uiModel.primaryColor,
                    style = WidyuTheme.typography.bold20.toTextStyle(),
                )

                Icon(
                    imageVector = uiModel.icon,
                    contentDescription = "심박 상태",
                    modifier = Modifier.size(70.dp),
                    tint = Color.Unspecified,
                )

                Row {
                    Text(
                        text = uiModel.heartRate,
                        modifier = Modifier.alignBy(FirstBaseline),
                        color = uiModel.heartRateTextColor,
                        style = WidyuTheme.typography.bold32.toTextStyle(),
                    )

                    Spacer(modifier = Modifier.width(WidyuTheme.spacing.spaceXSmall))

                    Text(
                        text = "BPM",
                        modifier = Modifier.alignBy(FirstBaseline),
                        color = WidyuTheme.colors.gray700,
                        style = WidyuTheme.typography.medium16.toTextStyle(),
                    )
                }
            }
        }
    }
}

@Preview(
    showBackground = true,
    name = "워치 연결 해제",
    uiMode = Configuration.UI_MODE_TYPE_WATCH,
)
@Composable
private fun WatchDisconnectScreenPreview() {
    WidyuTheme {
        WidyuScreen(
            uiModel = UiState.WatchDisconnect.toUiModel()!!,
        )
    }
}

@Preview(
    showBackground = true,
    name = "안정",
    uiMode = Configuration.UI_MODE_TYPE_WATCH,
)
@Composable
private fun StableScreenPreview() {
    WidyuTheme {
        WidyuScreen(
            uiModel = UiState.Stable(90).toUiModel()!!,
        )
    }
}

@Preview(
    showBackground = true,
    name = "주의",
    uiMode = Configuration.UI_MODE_TYPE_WATCH,
)
@Composable
private fun CautionScreenPreview() {
    WidyuTheme {
        WidyuScreen(
            uiModel = UiState.Caution(142).toUiModel()!!,
        )
    }
}
