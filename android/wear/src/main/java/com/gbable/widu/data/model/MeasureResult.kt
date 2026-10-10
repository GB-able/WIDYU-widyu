package com.gbable.widu.data.model

sealed interface MeasureResult {
    data class Availability(
        val isAvailable: Boolean,
        /** 착용 여부. 기기가 알려주지 않는 사유(측정 불가 등)면 null = 알 수 없음. */
        val isOnBody: Boolean? = null,
    ) : MeasureResult

    /** [value] 는 화면 표시용 최신 값(믿을 만한 샘플이 없으면 null), [readings] 는 전송할 원 샘플 전부다. */
    data class HeartRate(
        val value: Int?,
        val readings: List<HeartRateReading> = emptyList(),
    ) : MeasureResult {
        init {
            require(value == null || value > 0) { HEART_RATE_ERROR }
        }

        companion object {
            private const val HEART_RATE_ERROR = "심박수는 자연수여야 합니다."
        }
    }

    data object SessionSuperseded : MeasureResult
}
