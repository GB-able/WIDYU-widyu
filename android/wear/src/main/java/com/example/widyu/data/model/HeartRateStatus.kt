package com.example.widyu.data.model

enum class HeartRateStatus {
    STABLE,
    CAUTION,
    UNKNOWN,
    ;

    companion object {
        fun from(value: String): HeartRateStatus =
            when (value) {
                "NORMAL" -> STABLE
                "ANOMALY" -> CAUTION
                else -> UNKNOWN
            }
    }
}
