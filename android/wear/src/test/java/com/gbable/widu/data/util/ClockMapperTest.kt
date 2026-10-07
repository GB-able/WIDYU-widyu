package com.gbable.widu.data.util

import io.kotest.matchers.shouldBe
import io.kotest.matchers.shouldNotBe
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class ClockMapperTest {
    private val mapper = ClockMapper(jumpToleranceMs = 50.0)

    @Test
    @DisplayName("첫 앵커에 clock_mapping_id 를 발급한다")
    fun issuesAnIdForTheFirstAnchor() {
        // when
        val info = mapper.onAnchor("boot-1", 1_000_000_000L, 1_760_000_000_000L, 2.0)

        // then
        info.clockMappingId shouldNotBe ""
        info.anchorElapsedNs shouldBe 1_000_000_000L
        info.anchorEpochMs shouldBe 1_760_000_000_000L
    }

    @Test
    @DisplayName("오차가 허용치 안이면 id 와 앵커 값을 모두 그대로 둔다")
    fun keepsTheIdWhenTheClockDidNotJump() {
        // given
        val first = mapper.onAnchor("boot-1", 1_000_000_000L, 1_760_000_000_000L, 2.0)

        // when — 10분 뒤, 10ms 만 어긋남
        val second = mapper.onAnchor("boot-1", 601_000_000_000L, 1_760_000_600_010L, 2.0)

        // then — 같은 id 의 기준점이 바뀌면 서버가 거절한다(SENSOR_4090)
        second shouldBe first
    }

    @Test
    @DisplayName("벽시계가 허용치를 넘어 점프하면 새 id 를 발급한다")
    fun issuesANewIdOnAClockJump() {
        // given
        val first = mapper.onAnchor("boot-1", 1_000_000_000L, 1_760_000_000_000L, 2.0)

        // when — 10분 뒤인데 벽시계는 5초 밀림
        val second = mapper.onAnchor("boot-1", 601_000_000_000L, 1_760_000_605_000L, 2.0)

        // then
        second.clockMappingId shouldNotBe first.clockMappingId
    }

    @Test
    @DisplayName("bootId 가 바뀌면 새 id 를 발급한다")
    fun issuesANewIdOnReboot() {
        // given
        val first = mapper.onAnchor("boot-1", 601_000_000_000L, 1_760_000_600_000L, 2.0)

        // when
        val second = mapper.onAnchor("boot-2", 1_000_000_000L, 1_760_000_601_000L, 2.0)

        // then
        second.clockMappingId shouldNotBe first.clockMappingId
        second.bootId shouldBe "boot-2"
    }
}
