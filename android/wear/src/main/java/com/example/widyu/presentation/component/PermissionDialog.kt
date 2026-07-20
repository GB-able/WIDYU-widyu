package com.example.widyu.presentation.component

import android.content.res.Configuration
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.size
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.vectorResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.ButtonDefaults
import androidx.wear.compose.material.Icon
import androidx.wear.compose.material.Text
import androidx.wear.compose.material.dialog.Dialog
import com.example.widyu.R
import com.example.widyu.presentation.theme.WidyuTheme

@Composable
fun PermissionDialog(
    showDialog: Boolean,
    onNavigateClick: () -> Unit,
    onDismiss: () -> Unit,
    title: String,
    description: String,
    modifier: Modifier = Modifier,
) {
    Dialog(
        showDialog = showDialog,
        onDismissRequest = onDismiss,
        modifier = modifier,
    ) {
        PermissionDialogContent(
            onNavigateClick = onNavigateClick,
            title = title,
            description = description,
            modifier = Modifier.fillMaxSize(),
        )
    }
}

@Composable
private fun PermissionDialogContent(
    onNavigateClick: () -> Unit,
    title: String,
    description: String,
    modifier: Modifier = Modifier,
) {
    Column(
        modifier = modifier,
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        Icon(
            imageVector = ImageVector.vectorResource(R.drawable.ic_stable),
            contentDescription = "권한 안내",
            modifier = Modifier.size(20.dp),
            tint = Color.Unspecified,
        )

        Spacer(modifier = Modifier.height(WidyuTheme.spacing.spaceMedium))

        Text(
            text = title,
            color = WidyuTheme.colors.white,
            style = WidyuTheme.typography.semibold16.toTextStyle(),
        )

        Spacer(modifier = Modifier.height(WidyuTheme.spacing.spaceSmall))

        Text(
            text = description,
            color = WidyuTheme.colors.gray500,
            style =
                WidyuTheme.typography.medium12
                    .copy(lineHeight = 16.dp, textAlign = TextAlign.Center)
                    .toTextStyle(),
        )

        Spacer(modifier = Modifier.height(WidyuTheme.spacing.spaceMedium))

        Button(
            onClick = onNavigateClick,
            modifier = Modifier.size(width = 112.dp, height = 28.dp),
            colors =
                ButtonDefaults.buttonColors(
                    backgroundColor = WidyuTheme.colors.primary,
                    disabledBackgroundColor = WidyuTheme.colors.gray500,
                    contentColor = WidyuTheme.colors.white,
                    disabledContentColor = WidyuTheme.colors.white,
                ),
        ) {
            Text(
                text = "설정으로 이동",
                color = WidyuTheme.colors.white,
                style = WidyuTheme.typography.semibold12.toTextStyle(),
            )
        }
    }
}

@Preview(
    showBackground = true,
    uiMode = Configuration.UI_MODE_TYPE_WATCH,
)
@Composable
private fun PermissionDialogPreview() {
    WidyuTheme {
        PermissionDialog(
            showDialog = true,
            onNavigateClick = {},
            onDismiss = {},
            title = "항상 허용 권한 요청",
            description = "착용 중 정확한 실시간 심박수\n측정을 위해 센서의 권한이 필요합니다.\n설정으로 이동해서 센서 권한을\n항상 허용으로 설정해주세요.",
        )
    }
}
