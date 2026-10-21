package com.widucorp.widu.data.util

import com.widucorp.widu.data.model.ImuSample

/**
 * 최근 [windowNs] 구간의 자이로 샘플만 들고 있는 링버퍼. Android 의존성 없음.
 *
 * 충격 직전 구간은 미리 켜 둔 이 버퍼로만 확보된다 — 사건이 난 뒤에 과거를 되돌려 받을 수 없다. (A 1.6.4)
 */
class GyroRingBuffer(
    private val windowNs: Long,
) {
    private val samples = ArrayDeque<ImuSample>()

    fun add(sample: ImuSample) {
        samples.addLast(sample)
        val oldest = sample.timestampNs - windowNs
        while (samples.isNotEmpty() && samples.first().timestampNs < oldest) samples.removeFirst()
    }

    /** `[eventNs - windowNs, eventNs)` 구간의 샘플. 오래된 것부터. */
    fun takeBefore(eventNs: Long): List<ImuSample> {
        val from = eventNs - windowNs
        return samples.filter { it.timestampNs in from until eventNs }
    }
}
