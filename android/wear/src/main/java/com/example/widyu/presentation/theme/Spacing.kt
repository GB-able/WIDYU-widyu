package com.example.widyu.presentation.theme

import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

@Immutable
data class WidyuSpacing(
    val spaceXSmall: Dp = 8.dp,
    val spaceSmall: Dp = 12.dp,
    val spaceMedium: Dp = 16.dp,
    val spaceLarge: Dp = 20.dp,
    val spaceXLarge: Dp = 40.dp,
)

val LocalWidyuSpacing = staticCompositionLocalOf { WidyuSpacing() }
