package com.gbable.widu.presentation.theme

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

@Immutable
data class WidyuSpacing(
    val space2XSmall: Dp = 2.dp,
    val spaceXSmall: Dp = 4.dp,
    val spaceSmall: Dp = 6.dp,
    val spaceMedium: Dp = 8.dp,
    val spaceLarge: Dp = 10.dp,
    val spaceXLarge: Dp = 16.dp,
    val space2XLarge: Dp = 20.dp,
)

val LocalWidyuSpacing = staticCompositionLocalOf { WidyuSpacing() }
