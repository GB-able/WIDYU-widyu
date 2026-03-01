package com.example.widyu.data.model

import java.time.LocalDateTime

sealed interface MeasureResult {
    data class Availability(
        val isAvailable: Boolean,
    ) : MeasureResult

    data class HeartRate(
        val value: Int,
        val isStable: Boolean? = null,
        val timeStamp: LocalDateTime = LocalDateTime.now(),
    ) : MeasureResult {
        init {
            require(value > 0) { HEART_RATE_ERROR }
        }

        companion object {
            private const val HEART_RATE_ERROR = "심박수는 자연수여야 합니다."
        }
    }
}
