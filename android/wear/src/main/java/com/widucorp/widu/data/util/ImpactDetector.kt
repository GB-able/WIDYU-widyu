package com.widucorp.widu.data.util

import com.widucorp.widu.data.model.ImuSample
import kotlin.math.sqrt

/**
 * 가속도 세 축의 크기 `SMV = sqrt(ax²+ay²+az²)` [g] 가 [impactG] 이상인지 본다. Android 의존성 없음.
 * 이것은 낙상 판정이 아니다 — 자이로를 보강해 보낼 구간을 고르는 신호일 뿐이다. (A 1.6.4)
 */
class ImpactDetector(
    private val impactG: Float,
) {
    /** 충격이면 그때의 SMV(g), 아니면 null. 자이로 샘플은 언제나 null. */
    fun check(sample: ImuSample): Float? {
        if (sample.type != ImuSample.Type.ACC) return null
        val smvG = sqrt(sample.x * sample.x + sample.y * sample.y + sample.z * sample.z) / STANDARD_GRAVITY
        return if (smvG >= impactG) smvG else null
    }

    private companion object {
        const val STANDARD_GRAVITY = 9.80665f
    }
}
