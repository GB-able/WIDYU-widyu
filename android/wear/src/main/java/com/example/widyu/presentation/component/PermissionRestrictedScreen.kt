package com.example.widyu.presentation.component

import android.content.res.Configuration
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.ButtonDefaults
import androidx.wear.compose.material.Text
import com.example.widyu.presentation.theme.WidyuTheme

@Composable
fun PermissionRestrictedScreen(
    buttonText: String,
    onActionClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(
        modifier =
            modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp, vertical = 28.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        Text(
            text = "권한이 필요해요",
            color = WidyuTheme.colors.white,
            style = WidyuTheme.typography.semibold16.toTextStyle(),
        )

        Spacer(modifier = Modifier.height(WidyuTheme.spacing.spaceSmall))

        Text(
            text = "심박수 측정 기능을 사용할 수 없어요.\n알림 및 센서 권한을 허용해 주세요.",
            color = WidyuTheme.colors.gray500,
            style =
                WidyuTheme.typography.medium12
                    .copy(lineHeight = 16.dp, textAlign = TextAlign.Center)
                    .toTextStyle(),
        )

        Spacer(modifier = Modifier.height(WidyuTheme.spacing.spaceMedium))

        Button(
            onClick = onActionClick,
            modifier = Modifier.size(width = 100.dp, height = 28.dp),
            colors =
                ButtonDefaults.buttonColors(
                    backgroundColor = WidyuTheme.colors.primary,
                    disabledBackgroundColor = WidyuTheme.colors.gray500,
                    contentColor = WidyuTheme.colors.white,
                    disabledContentColor = WidyuTheme.colors.white,
                ),
        ) {
            Text(
                text = buttonText,
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
private fun PermissionRestrictedScreenPreview() {
    WidyuTheme {
        PermissionRestrictedScreen(buttonText = "권한 허용", onActionClick = {})
    }
}
