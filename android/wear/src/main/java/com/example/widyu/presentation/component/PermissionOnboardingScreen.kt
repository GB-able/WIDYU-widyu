package com.example.widyu.presentation.component

import android.content.res.Configuration
import androidx.compose.foundation.ScrollState
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
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
import com.example.widyu.R
import com.example.widyu.presentation.theme.WidyuTheme
import java.security.Permission

@Composable
fun PermissionOnboardingScreen(
    scrollState: ScrollState,
    onConfirmClick: () -> Unit,
    modifier: Modifier = Modifier,
) {
    Column(
        modifier =
            modifier
                .fillMaxSize()
                .verticalScroll(scrollState)
                .padding(horizontal = 16.dp, vertical = 28.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        Text(
            text = "필수 권한 안내",
            color = WidyuTheme.colors.white,
            style = WidyuTheme.typography.semibold16.toTextStyle(),
        )

        Spacer(modifier = Modifier.height(WidyuTheme.spacing.spaceSmall))

        Text(
            text = "심박수를 측정하려면\n아래 권한이 필요해요.",
            color = WidyuTheme.colors.gray300,
            style =
                WidyuTheme.typography.medium12
                    .copy(lineHeight = 16.dp, textAlign = TextAlign.Center)
                    .toTextStyle(),
        )

        Spacer(modifier = Modifier.height(WidyuTheme.spacing.spaceSmall))

        Column(
            modifier =
                Modifier
                    .size(width = 128.dp, height = 64.dp)
                    .background(
                        color = WidyuTheme.colors.gray900,
                        shape = RoundedCornerShape(10.dp),
                    ).padding(WidyuTheme.spacing.spaceSmall),
            verticalArrangement = Arrangement.Center,
        ) {
            PermissionContent(
                resId = R.drawable.ic_notification,
                title = "알림",
                description = "앱 실행 알림",
            )

            Spacer(modifier = Modifier.height(WidyuTheme.spacing.spaceXSmall))

            PermissionContent(
                resId = R.drawable.ic_heart_rate,
                title = "센서",
                description = "실시간 심박수 측정",
            )
        }

        Spacer(modifier = Modifier.height(WidyuTheme.spacing.spaceXLarge))

        Button(
            onClick = onConfirmClick,
            modifier = Modifier.size(width = 65.dp, height = 28.dp),
            colors =
                ButtonDefaults.buttonColors(
                    backgroundColor = WidyuTheme.colors.primary,
                    disabledBackgroundColor = WidyuTheme.colors.gray500,
                    contentColor = WidyuTheme.colors.white,
                    disabledContentColor = WidyuTheme.colors.white,
                ),
        ) {
            Text(
                text = "확인",
                color = WidyuTheme.colors.white,
                style = WidyuTheme.typography.semibold12.toTextStyle(),
            )
        }
    }
}

@Composable
private fun PermissionContent(
    resId: Int,
    title: String,
    description: String,
    modifier: Modifier = Modifier,
) {
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Icon(
            imageVector = ImageVector.vectorResource(resId),
            contentDescription = "권한 안내",
            modifier = Modifier.size(size = 20.dp),
            tint = Color.Unspecified,
        )

        Spacer(modifier = Modifier.width(WidyuTheme.spacing.spaceSmall))

        Column {
            Text(
                text = title,
                color = WidyuTheme.colors.white,
                style = WidyuTheme.typography.semibold10.toTextStyle(),
            )

            Spacer(modifier = Modifier.height(WidyuTheme.spacing.space2XSmall))

            Text(
                text = description,
                color = WidyuTheme.colors.gray500,
                style = WidyuTheme.typography.medium8.toTextStyle(),
            )
        }
    }
}

@Preview(
    showBackground = true,
    uiMode = Configuration.UI_MODE_TYPE_WATCH,
)
@Composable
private fun PermissionOnboardingScreenPreview() {
    WidyuTheme {
        PermissionOnboardingScreen(
            scrollState = rememberScrollState(),
            onConfirmClick = {},
        )
    }
}
