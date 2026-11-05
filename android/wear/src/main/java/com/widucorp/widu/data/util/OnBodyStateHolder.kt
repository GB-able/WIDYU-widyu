package com.widucorp.widu.data.util

import com.widucorp.widu.data.model.HeartRateAccuracyLabel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import javax.inject.Inject
import javax.inject.Singleton

/** 착용 여부. Health Services 가용성 콜백만이 알려주므로 심박 세션이 도는 동안만 갱신되고, null 은 「아직 모른다」다. */
@Singleton
class OnBodyStateHolder @Inject constructor() {
    private val _state = MutableStateFlow<Boolean?>(null)
    val state: StateFlow<Boolean?> = _state

    /** 가장 최근 심박 샘플의 정확도([HeartRateAccuracyLabel]). 벗으면 비워서 다시 찰 때 예전 값이 남지 않게 한다. */
    @Volatile
    private var heartRateAccuracy: String? = null

    fun update(isOnBody: Boolean?) {
        _state.value = isOnBody
        if (isOnBody != true) heartRateAccuracy = null
    }

    fun updateHeartRateAccuracy(accuracy: String) {
        heartRateAccuracy = accuracy
    }

    /** IMU 배치 `wear_state` 값. */
    fun wearState(): String =
        when (_state.value) {
            null -> WearState.UNKNOWN
            false -> WearState.ACTUAL_NOT_WORN
            true ->
                // 신호를 확인한 경우만 믿는다. LOW·UNRELIABLE·UNKNOWN 과, 차고 나서 아직 심박이 오지 않은 null 은 INVALID.
                when (heartRateAccuracy) {
                    HeartRateAccuracyLabel.HIGH, HeartRateAccuracyLabel.MEDIUM -> WearState.WORN_VALID
                    else -> WearState.WORN_INVALID
                }
        }
}

object WearState {
    const val UNKNOWN = "UNKNOWN"
    const val ACTUAL_NOT_WORN = "ACTUAL_NOT_WORN"
    const val WORN_INVALID = "WORN_INVALID"
    const val WORN_VALID = "WORN_VALID"
}
