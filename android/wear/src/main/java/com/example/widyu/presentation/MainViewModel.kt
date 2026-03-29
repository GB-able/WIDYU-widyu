package com.example.widyu.presentation

import android.util.Log
import androidx.compose.runtime.Stable
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.widyu.data.model.HeartRateStatus
import com.example.widyu.data.model.MeasureResult
import com.example.widyu.data.repository.HeartRateRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import javax.inject.Inject

@Stable
@HiltViewModel
class MainViewModel @Inject constructor(
    private val repository: HeartRateRepository,
) : ViewModel() {
    private val _uiState: MutableStateFlow<UiState> = MutableStateFlow(UiState.Loading)
    val uiState: StateFlow<UiState> = _uiState.asStateFlow()

    private var currentHeartRate: Int = 0

    init {
        observeServerResponse()
    }

    fun checkSupported() {
        viewModelScope.launch {
            repository
                .hasHeartRateCapability()
                .onSuccess { isSupported ->
                    if (isSupported) {
                        fetchMeasureResult()
                        return@launch
                    }
                    updateState { UiState.WatchDisconnect }
                }.onFailure {
                    Log.i("Widyu", "Error", it)
                    updateState { UiState.WatchDisconnect }
                }
        }
    }

    private fun fetchMeasureResult() {
        repository
            .getHeartRate()
            .catch {
                Log.i("Widyu", "Error", it)
                updateState { UiState.WatchDisconnect }
            }.onEach { measureResult ->
                when (measureResult) {
                    is MeasureResult.Availability -> {
                        if (measureResult.isAvailable.not()) updateState { UiState.WatchDisconnect }
                    }

                    is MeasureResult.HeartRate -> {
                        currentHeartRate = measureResult.value
                        updateState {
                            val isStable = measureResult.isStable
                            if (isStable == null || isStable) {
                                UiState.Stable(measureResult.value)
                            } else {
                                UiState.Caution(measureResult.value)
                            }
                        }
                    }
                }
            }.launchIn(viewModelScope)
    }

    private fun observeServerResponse() {
        repository
            .getHeartRateStatus()
            .onEach { response ->
                updateState {
                    when (response) {
                        HeartRateStatus.STABLE -> UiState.Stable(currentHeartRate)
                        HeartRateStatus.CAUTION -> UiState.Caution(currentHeartRate)
                        HeartRateStatus.UNKNOWN -> this
                    }
                }
            }.launchIn(viewModelScope)
    }

    private fun updateState(reducer: UiState.() -> UiState) {
        _uiState.update { state -> state.reducer() }
    }
}
