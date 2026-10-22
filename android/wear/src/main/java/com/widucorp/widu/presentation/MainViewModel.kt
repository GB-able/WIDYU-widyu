package com.widucorp.widu.presentation

import android.util.Log
import androidx.compose.runtime.Stable
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.widucorp.widu.data.model.HeartRateStatus
import com.widucorp.widu.data.model.MeasureResult
import com.widucorp.widu.data.repository.HeartRateRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.filter
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import javax.inject.Inject

@Stable
@HiltViewModel
class MainViewModel @Inject constructor(
    private val repository: HeartRateRepository,
) : ViewModel() {
    private val measureState: MutableStateFlow<MeasureState> = MutableStateFlow(MeasureState.Loading)
    private val heartRate: MutableStateFlow<Int> = MutableStateFlow(0)
    private val heartRateStatus: MutableStateFlow<HeartRateStatus> = MutableStateFlow(HeartRateStatus.STABLE)

    val uiState: StateFlow<UiState> =
        combine(measureState, heartRate, heartRateStatus) { measure, hr, status ->
            when (measure) {
                MeasureState.Loading -> {
                    UiState.Loading
                }

                MeasureState.Disconnected -> {
                    UiState.WatchDisconnect
                }

                MeasureState.Measuring -> {
                    when (status) {
                        HeartRateStatus.CAUTION -> UiState.Caution(hr)
                        else -> UiState.Stable(hr)
                    }
                }
            }
        }.stateIn(
            viewModelScope,
            SharingStarted.Eagerly,
            UiState.Loading,
        )

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
                    measureState.value = MeasureState.Disconnected
                }.onFailure {
                    Log.i("Widyu", "Error", it)
                    measureState.value = MeasureState.Disconnected
                }
        }
    }

    private fun fetchMeasureResult() {
        repository
            .getHeartRate()
            .catch {
                Log.i("Widyu", "Error", it)
                measureState.value = MeasureState.Disconnected
            }.onEach { measureResult ->
                when (measureResult) {
                    is MeasureResult.Availability -> {
                        if (measureResult.isAvailable.not()) measureState.value = MeasureState.Disconnected
                    }

                    is MeasureResult.HeartRate -> {
                        // 믿을 만한 샘플이 없던 묶음은 화면 값을 바꾸지 않는다.
                        val value = measureResult.value ?: return@onEach
                        heartRate.value = value
                        measureState.value = MeasureState.Measuring
                    }

                    is MeasureResult.SessionSuperseded -> {
                        measureState.value = MeasureState.Disconnected
                    }
                }
            }.launchIn(viewModelScope)
    }

    private fun observeServerResponse() {
        repository
            .getHeartRateStatus()
            .filter { response -> response != HeartRateStatus.UNKNOWN }
            .onEach { response -> heartRateStatus.value = response }
            .launchIn(viewModelScope)
    }

    private sealed interface MeasureState {
        object Loading : MeasureState

        object Measuring : MeasureState

        object Disconnected : MeasureState
    }
}
