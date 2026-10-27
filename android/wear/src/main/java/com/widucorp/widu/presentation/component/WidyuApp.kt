package com.widucorp.widu.presentation.component

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.wear.compose.material.Scaffold
import androidx.wear.compose.material.TimeText
import com.widucorp.widu.presentation.theme.WidyuTheme

@Composable
fun WidyuApp() {
    Scaffold(
        modifier = Modifier.fillMaxSize(),
        timeText = {
            TimeText(
                timeTextStyle =
                    WidyuTheme.typography.semibold16
                        .copy(color = WidyuTheme.colors.gray700)
                        .toTextStyle(),
            )
        },
    ) {
        WidyuScreen()
    }
}
