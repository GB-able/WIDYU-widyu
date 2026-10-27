package com.widucorp.widu.data.model

enum class HeartRateStatus {
    STABLE,
    CAUTION,
    UNKNOWN,
    ;

    companion object {
        fun from(value: String): HeartRateStatus =
            when (value) {
                "NORMAL" -> STABLE
                "EMERGENCY" -> CAUTION
                else -> UNKNOWN
            }
    }
}
