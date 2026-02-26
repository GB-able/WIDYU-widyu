package com.example.widyu.presentation

import HeartRateRepository
import android.util.Log
import androidx.compose.runtime.Stable
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.widyu.data.model.MeasureResult
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

@Stable
@HiltViewModel
class MainViewModel(
    private val repository: HeartRateRepository,
) : ViewModel() {
    private val _uiState: MutableStateFlow<UiState> = MutableStateFlow(UiState.Loading)
    val uiState: StateFlow<UiState> = _uiState.asStateFlow()

    init {
        checkSupported()
    }

    private fun checkSupported() {
        viewModelScope.launch {
            repository
                .hasHeartRateCapability()
                .onSuccess { isSupported ->
                    if (isSupported) {
                        fetchMeasureResult()
                        return@launch
                    }
                    updateState { UiState.Disconnect }
                }.onFailure {
                    updateState { UiState.Disconnect }
                }
        }
    }

    private fun fetchMeasureResult() {
        repository
            .getHeartRate()
            .catch {
                Log.i("Widyu", it.stackTraceToString())
                updateState { UiState.Disconnect }
            }.onEach { measureResult ->
                when (measureResult) {
                    is MeasureResult.Availability -> {
                        if (measureResult.isAvailable.not()) updateState { UiState.Disconnect }
                    }

                    is MeasureResult.HeartRate ->
                        updateState {
                            val isStable = measureResult.isStable
                            if (isStable == null || isStable) {
                                UiState.Stable(measureResult.value)
                            } else {
                                UiState.Caution(measureResult.value)
                            }
                        }
                }
            }.launchIn(viewModelScope)
    }

    private fun updateState(reducer: UiState.() -> UiState) {
        _uiState.update { state -> state.reducer() }
    }
}
