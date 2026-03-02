package com.example.widyu.presentation.component

import android.Manifest
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
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
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
import com.example.widyu.presentation.MainViewModel
import com.example.widyu.presentation.UiState
import com.example.widyu.presentation.model.UiModel
import com.example.widyu.presentation.model.UiModel.Companion.toUiModel
import com.example.widyu.presentation.theme.WidyuTheme
import com.example.widyu.presentation.util.PermissionManager.openAppSettings
import com.example.widyu.presentation.util.rememberPermissionLauncher

@Composable
fun WidyuScreen(viewModel: MainViewModel = hiltViewModel()) {
    val activity = LocalActivity.current ?: return
    val context = LocalContext.current
    val permissionLauncher =
        rememberPermissionLauncher(
            activity = activity,
            onGranted = viewModel::checkSupported,
            onRequireRuntimePermission = {},
            onRequireBackgroundPermission = { openAppSettings(context) },
        )

    LifecycleEventEffect(Lifecycle.Event.ON_RESUME) {
        permissionLauncher.launch(Manifest.permission.BODY_SENSORS)
    }

    val uiState = viewModel.uiState.collectAsStateWithLifecycle().value
    val uiModel = uiState.toUiModel()

    if (uiModel != null) {
        WidyuScreen(uiModel)
    } else {
        WidyuLoadingIndicator()
    }
}

@Composable
private fun WidyuScreen(uiModel: UiModel) {
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
                style = WidyuTheme.typography.bold40.toTextStyle(),
            )

            Icon(
                imageVector = uiModel.icon,
                contentDescription = "심박 상태",
                modifier = Modifier.size(180.dp),
                tint = Color.Unspecified,
            )

            Row {
                Text(
                    text = uiModel.heartRate,
                    modifier = Modifier.alignBy(FirstBaseline),
                    color = uiModel.heartRateTextColor,
                    style = WidyuTheme.typography.bold58.toTextStyle(),
                )

                Spacer(modifier = Modifier.width(WidyuTheme.spacing.spaceXSmall))

                Text(
                    text = "BPM",
                    modifier = Modifier.alignBy(FirstBaseline),
                    color = WidyuTheme.colors.gray700,
                    style = WidyuTheme.typography.medium32.toTextStyle(),
                )
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
