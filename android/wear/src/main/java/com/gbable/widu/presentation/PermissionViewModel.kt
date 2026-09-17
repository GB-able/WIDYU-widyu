package com.gbable.widu.presentation

import androidx.compose.runtime.Stable
import androidx.lifecycle.ViewModel
import com.gbable.widu.data.source.OnboardingLocalDataSource
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import javax.inject.Inject

@Stable
@HiltViewModel
class PermissionViewModel @Inject constructor(
    private val onboardingLocalDataSource: OnboardingLocalDataSource,
) : ViewModel() {
    private val _permissionState: MutableStateFlow<PermissionState> = MutableStateFlow(PermissionState.Loading)
    val permissionState: StateFlow<PermissionState> = _permissionState.asStateFlow()

    fun isOnboardingCompleted(): Boolean = onboardingLocalDataSource.isOnboardingCompleted()

    fun completeOnboarding() = onboardingLocalDataSource.setOnboardingCompleted()

    fun updatePermissionState(state: PermissionState) = _permissionState.update { state }
}
