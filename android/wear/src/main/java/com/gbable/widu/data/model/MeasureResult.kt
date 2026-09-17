package com.gbable.widu.data.model

sealed interface MeasureResult {
    data class Availability(
        val isAvailable: Boolean,
    ) : MeasureResult

    data class HeartRate(
        val value: Int,
    ) : MeasureResult {
        init {
            require(value > 0) { HEART_RATE_ERROR }
        }

        companion object {
            private const val HEART_RATE_ERROR = "심박수는 자연수여야 합니다."
        }
    }

    data object SessionSuperseded : MeasureResult
}
