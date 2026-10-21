package com.widucorp.widu.data.util

import com.widucorp.widu.data.model.ClockInfo
import java.util.UUID
import kotlin.math.abs

/**
 * 앵커(단조 시각 ↔ 벽시계) 한 쌍에 이름을 붙인다.
 * 서버는 같은 clock_mapping_id 의 기준점 값이 바뀌면 거절한다(SENSOR_4090).
 * 그래서 재부팅이나 시각 점프가 아니면 이전 앵커를 그대로 쓰고, 그때만 새 id 와 새 앵커를 발급한다.
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
        if (prev != null && prev.bootId == bootId && abs(predictEpochMs(prev, elapsedNs) - epochMs) <= jumpToleranceMs) {
            return prev
        }
        return ClockInfo(bootId, UUID.randomUUID().toString(), elapsedNs, epochMs, uncertaintyMs).also { previous = it }
    }

    private fun predictEpochMs(
        prev: ClockInfo,
        elapsedNs: Long,
    ): Double = prev.anchorEpochMs + (elapsedNs - prev.anchorElapsedNs) / 1e6
}
