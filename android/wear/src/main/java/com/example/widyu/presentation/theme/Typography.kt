package com.example.widyu.presentation.theme

import androidx.compose.runtime.Composable
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.Stable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.em
import com.example.widyu.R

val Pretendard =
    FontFamily(
        Font(R.font.pretendard_medium, FontWeight.W500),
        Font(R.font.pretendard_semibold, FontWeight.W600),
        Font(R.font.pretendard_bold, FontWeight.W700),
    )

@Immutable
data class WidyuTextStyle(
    val fontFamily: FontFamily = Pretendard,
    val fontWeight: FontWeight = FontWeight.Medium,
    val fontSize: Dp = Dp.Unspecified,
    val lineHeight: Dp = Dp.Unspecified,
    val letterSpacing: TextUnit = 0.em,
    val color: Color = Color.Unspecified,
    val textAlign: TextAlign = TextAlign.Start,
) {
    @Composable
    fun toTextStyle(): TextStyle =
        TextStyle(
            fontFamily = fontFamily,
            fontWeight = fontWeight,
            fontSize = with(LocalDensity.current) { fontSize.toSp() },
            lineHeight = with(LocalDensity.current) { lineHeight.toSp() },
            letterSpacing = letterSpacing,
            color = color,
            textAlign = textAlign,
        )

    companion object {
        @Stable
        val Default = WidyuTextStyle()
    }
}

@Immutable
data class WidyuTypography(
    val medium12: WidyuTextStyle =
        WidyuTextStyle(
            fontFamily = Pretendard,
            fontWeight = FontWeight.W500,
            fontSize = 12.dp,
            lineHeight = 12.dp,
        ),
    val medium16: WidyuTextStyle =
        WidyuTextStyle(
            fontFamily = Pretendard,
            fontWeight = FontWeight.W500,
            fontSize = 16.dp,
            lineHeight = 16.dp,
        ),
    val medium8: WidyuTextStyle =
        WidyuTextStyle(
            fontFamily = Pretendard,
            fontWeight = FontWeight.W500,
            fontSize = 8.dp,
            lineHeight = 8.dp,
        ),
    val semibold10: WidyuTextStyle =
        WidyuTextStyle(
            fontFamily = Pretendard,
            fontWeight = FontWeight.W600,
            fontSize = 10.dp,
            lineHeight = 10.dp,
        ),
    val semibold12: WidyuTextStyle =
        WidyuTextStyle(
            fontFamily = Pretendard,
            fontWeight = FontWeight.W600,
            fontSize = 12.dp,
            lineHeight = 12.dp,
        ),
    val semibold16: WidyuTextStyle =
        WidyuTextStyle(
            fontFamily = Pretendard,
            fontWeight = FontWeight.W600,
            fontSize = 16.dp,
            lineHeight = 16.dp,
        ),
    val bold20: WidyuTextStyle =
        WidyuTextStyle(
            fontFamily = Pretendard,
            fontWeight = FontWeight.W700,
            fontSize = 20.dp,
            lineHeight = 20.dp,
        ),
    val bold32: WidyuTextStyle =
        WidyuTextStyle(
            fontFamily = Pretendard,
            fontWeight = FontWeight.W700,
            fontSize = 32.dp,
            lineHeight = 32.dp,
        ),
)

val LocalWidyuTypography = staticCompositionLocalOf { WidyuTypography() }
