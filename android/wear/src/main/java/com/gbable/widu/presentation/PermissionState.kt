package com.gbable.widu.presentation

import androidx.compose.runtime.Stable

@Stable
sealed interface PermissionState {
    object Loading : PermissionState

    object Onboarding : PermissionState

    object Restricted : PermissionState

    object Granted : PermissionState
}
