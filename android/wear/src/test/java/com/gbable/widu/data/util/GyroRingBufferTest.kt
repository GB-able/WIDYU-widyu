package com.gbable.widu.data.util

import com.gbable.widu.data.model.ImuSample
import io.kotest.matchers.shouldBe
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class GyroRingBufferTest {
    private val buffer = GyroRingBuffer(windowNs = TWO_SECONDS_NS)

    @Test
    @DisplayName("창 밖으로 밀려난 샘플은 버린다")
    fun dropsSamplesOutsideTheWindow() {
        // given — 0.5초 간격 다섯 개, 마지막이 2.0초
        repeat(5) { buffer.add(gyroAt(it * HALF_SECOND_NS)) }

        // when — 마지막 샘플(2.0초) 기준 창은 [0, 2.0초)
        val kept = buffer.takeBefore(TWO_SECONDS_NS)

        // then — 0 초 샘플은 경계 안이라 남고, 2.0 초 샘플은 구간 밖이다
        kept.map { it.timestampNs } shouldBe listOf(0L, HALF_SECOND_NS, 2 * HALF_SECOND_NS, 3 * HALF_SECOND_NS)
    }

    @Test
    @DisplayName("takeBefore 는 [event-창, event) 구간만 돌려준다")
    fun takesOnlyTheRequestedWindow() {
        // given — 0.5초 간격 아홉 개(0 ~ 4.0초)
        repeat(9) { buffer.add(gyroAt(it * HALF_SECOND_NS)) }

        // when
        val kept = buffer.takeBefore(eventNs = 6 * HALF_SECOND_NS)

        // then — 창 밖으로 밀려난 2.0초 이전 샘플은 이미 버려졌고, 3.0초부터는 구간 밖이다
        kept.map { it.timestampNs } shouldBe listOf(4 * HALF_SECOND_NS, 5 * HALF_SECOND_NS)
    }

    @Test
    @DisplayName("담긴 것이 없으면 빈 목록이다")
    fun emptyWhenNothingBuffered() {
        buffer.takeBefore(TWO_SECONDS_NS) shouldBe emptyList()
    }

    private fun gyroAt(timestampNs: Long) = ImuSample(ImuSample.Type.GYRO, timestampNs, 0.1f, 0.2f, 0.3f)

    private companion object {
        const val HALF_SECOND_NS = 500_000_000L
        const val TWO_SECONDS_NS = 2_000_000_000L
    }
}
