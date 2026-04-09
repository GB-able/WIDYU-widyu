package com.example.widyu.presentation

import androidx.compose.runtime.Stable

@Stable
sealed interface UiState {
    object Loading : UiState

    data class Stable(
        val heartRate: Int,
    ) : UiState

    data class Caution(
        val heartRate: Int,
    ) : UiState

    object WatchDisconnect : UiState
}
