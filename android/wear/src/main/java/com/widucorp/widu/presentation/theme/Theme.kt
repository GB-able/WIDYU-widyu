package com.widucorp.widu.presentation.theme

import androidx.annotation.RequiresPermission
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.ReadOnlyComposable

object WidyuTheme {
    val colors: WidyuColorSystem
        @Composable
        @ReadOnlyComposable
        get() = LocalWidyuColorSystem.current

    val spacing: WidyuSpacing
        @Composable
        @ReadOnlyComposable
        get() = LocalWidyuSpacing.current

    val typography: WidyuTypography
        @Composable
        @RequiresPermission.Read
        get() = LocalWidyuTypography.current
}

@Composable
fun WidyuTheme(content: @Composable () -> Unit) {
    CompositionLocalProvider(
        LocalWidyuColorSystem provides WidyuColorSystem(),
        LocalWidyuSpacing provides WidyuSpacing(),
        LocalWidyuTypography provides WidyuTypography(),
    ) {
        content()
    }
}
