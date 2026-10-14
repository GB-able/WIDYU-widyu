package com.gbable.widu.presentation.model

import androidx.compose.runtime.Composable
import androidx.compose.runtime.Immutable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.vectorResource
import com.gbable.widu.R
import com.gbable.widu.presentation.UiState
import com.gbable.widu.presentation.theme.WidyuTheme

@Immutable
data class UiModel(
    val heartRate: String,
    val heartRateTextColor: Color,
    val primaryColor: Color,
    val secondaryColor: Color,
    val tertiaryColor: Color,
    val text: String,
    val icon: ImageVector,
) {
    companion object {
        @Composable
        fun UiState.toUiModel(): UiModel? =
            when (this) {
                UiState.Loading -> null
                UiState.WatchDisconnect ->
                    UiModel(
                        heartRate = "-",
                        heartRateTextColor = WidyuTheme.colors.black,
                        primaryColor = WidyuTheme.colors.gray600,
                        secondaryColor = WidyuTheme.colors.gray300,
                        tertiaryColor = WidyuTheme.colors.gray100,
                        text = "연결 불가",
                        icon = ImageVector.vectorResource(R.drawable.ic_watch_off),
                    )

                is UiState.Stable ->
                    UiModel(
                        heartRate = heartRate.toString(),
                        heartRateTextColor = WidyuTheme.colors.black,
                        primaryColor = WidyuTheme.colors.purple300,
                        secondaryColor = WidyuTheme.colors.purple200,
                        tertiaryColor = WidyuTheme.colors.purple100,
                        text = "안정",
                        icon = ImageVector.vectorResource(R.drawable.ic_stable),
                    )

                is UiState.Caution ->
                    UiModel(
                        heartRate = heartRate.toString(),
                        heartRateTextColor = WidyuTheme.colors.red300,
                        primaryColor = WidyuTheme.colors.red300,
                        secondaryColor = WidyuTheme.colors.red200,
                        tertiaryColor = WidyuTheme.colors.red100,
                        text = "주의",
                        icon = ImageVector.vectorResource(R.drawable.ic_caution),
                    )
            }
    }
}
