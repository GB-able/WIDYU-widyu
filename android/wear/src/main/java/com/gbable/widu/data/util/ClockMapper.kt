package com.gbable.widu.data.util

import com.gbable.widu.data.model.ClockInfo
import java.util.UUID
import kotlin.math.abs

/**
 * 앵커(단조 시각 ↔ 벽시계) 한 쌍에 이름을 붙인다.
 * 재부팅이나 시각 점프로 환산이 달라지면 새 clock_mapping_id 를 발급한다.
 * 이미 발급한 값은 고치지 않는다.
 */
class ClockMapper(
    private val jumpToleranceMs: Double,
) {
    private var previous: ClockInfo? = null

    fun onAnchor(
        bootId: String,
        elapsedNs: Long,
        epochMs: Long,
        uncertaintyMs: Double,
    ): ClockInfo {
        val prev = previous
        val mappingId =
            when {
                prev == null || prev.bootId != bootId -> UUID.randomUUID().toString()
                abs(predictEpochMs(prev, elapsedNs) - epochMs) > jumpToleranceMs -> UUID.randomUUID().toString()
                else -> prev.clockMappingId
            }
        return ClockInfo(bootId, mappingId, elapsedNs, epochMs, uncertaintyMs).also { previous = it }
    }

    private fun predictEpochMs(
        prev: ClockInfo,
        elapsedNs: Long,
    ): Double = prev.anchorEpochMs + (elapsedNs - prev.anchorElapsedNs) / 1e6
}
