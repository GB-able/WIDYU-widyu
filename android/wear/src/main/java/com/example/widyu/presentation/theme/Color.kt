package com.example.widyu.presentation.theme

import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color

data class WidyuColorSystem(
    val transparent: Color = Color(0x00000000),
    val black: Color = Color(0xFF000000),
    val white: Color = Color(0xFFFFFFFF),
    val primary: Color = Color(0xFFFF7618),
    val purple100: Color = Color(0xFFEFDFFF),
    val purple200: Color = Color(0xFFDFC0FF),
    val purple300: Color = Color(0xFF7200E4),
    val red100: Color = Color(0xFFFFEBEB),
    val red200: Color = Color(0xFFFFCFCF),
    val red300: Color = Color(0xFFE41F10),
    val gray100: Color = Color(0xFFEBEBEB),
    val gray300: Color = Color(0xFFC9C9C9),
    val gray500: Color = Color(0xFF959595),
    val gray600: Color = Color(0xFF636363),
    val gray700: Color = Color(0xFF414141),
    val gray900: Color = Color(0xFF1F1F1F),
)

val LocalWidyuColorSystem = staticCompositionLocalOf { WidyuColorSystem() }
