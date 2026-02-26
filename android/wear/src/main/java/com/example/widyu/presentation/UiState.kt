package com.example.widyu.presentation

sealed interface UiState {
    object Loading : UiState

    data class Stable(
        val heartRate: Double,
    ) : UiState

    data class Caution(
        val heartRate: Double,
    ) : UiState

    object Disconnect : UiState
}
