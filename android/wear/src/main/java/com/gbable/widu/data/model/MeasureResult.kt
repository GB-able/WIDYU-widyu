package com.gbable.widu.data.model

sealed interface MeasureResult {
    data class Availability(
        val isAvailable: Boolean,
        /** 착용 여부. 기기가 알려주지 않는 사유(측정 불가 등)면 null = 알 수 없음. */
        val isOnBody: Boolean? = null,
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
