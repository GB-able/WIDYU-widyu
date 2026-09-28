package com.gbable.widu.data.util

import com.gbable.widu.data.model.AxisSeries
import com.gbable.widu.data.model.ClockInfo
import com.gbable.widu.data.model.ImuBatch
import io.kotest.matchers.collections.shouldContainAll
import io.kotest.matchers.shouldBe
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

/**
 * org.json 은 JVM 단위 테스트에서 스텁이라 실제로 동작하지 않는다.
 * 그래서 봉투 형식은 [ImuBatch.toMap] 에서 검증하고, JSON 변환은 그 위의 얇은 계층으로 분리했다.
 */
class ImuBatchJsonTest {
    private val batch =
        ImuBatch(
            batchId = "batch-1",
            deviceId = "gw-abc",
            sessionId = "session-1",
            seq = 88_213L,
            clock =
                ClockInfo(
                    bootId = "boot-1",
                    clockMappingId = "cm-1",
                    anchorElapsedNs = 993_847_100_000_001L,
                    anchorEpochMs = 1_760_000_000_000L,
                    uncertaintyMs = 2.0,
                ),
            acc =
                AxisSeries(
                    fsHzRequested = 50,
                    t0ElapsedNs = 993_847_112_340_001L,
                    dtNs = longArrayOf(19_998_417L, 20_003_005L),
                    values = listOf(intArrayOf(20, -980, 110), intArrayOf(22, -979, 108), intArrayOf(21, -980, 109)),
                ),
            gyroMode = "continuous",
            collectionMode = "product",
            watchBatteryPct = 63,
        )

    @Test
    @DisplayName("나노초 값은 자바스크립트 정수 범위를 넘으므로 10진 문자열로 싣는다")
    fun nanosecondValuesAreDecimalStrings() {
        // when
        val map = batch.toMap()
        val acc = map["acc"] as Map<*, *>
        val clock = map["clock"] as Map<*, *>

        // then
        acc["t0_elapsed_ns"] shouldBe "993847112340001"
        clock["anchor_elapsed_ns"] shouldBe "993847100000001"
    }

    @Test
    @DisplayName("dt_ns 는 길이 n-1 의 정수 배열이고 mg 는 n행 3열이다")
    fun dtNsAndMgShapes() {
        // when
        val acc = batch.toMap()["acc"] as Map<*, *>

        // then
        acc["n"] shouldBe 3
        acc["dt_ns"] shouldBe listOf(19_998_417L, 20_003_005L)
        acc["mg"] shouldBe listOf(listOf(20, -980, 110), listOf(22, -979, 108), listOf(21, -980, 109))
    }

    @Test
    @DisplayName("보내지 않는 필드도 키를 지우지 않고 null 로 남긴다")
    fun absentFieldsStayAsNullKeys() {
        // when
        val map = batch.toMap()

        // then
        map.keys shouldContainAll listOf("gyro", "trigger", "missing_reason")
        map["gyro"] shouldBe null
        map["trigger"] shouldBe null
        map["missing_reason"] shouldBe null
        map["study_id"] shouldBe null
        map["participation_id"] shouldBe null
        map["run_id"] shouldBe null
    }

    @Test
    @DisplayName("boot_id 와 clock_mapping_id 는 clock 안과 최상위 양쪽에 둔다")
    fun clockIdentifiersAppearAtBothLevels() {
        // when
        val map = batch.toMap()
        val clock = map["clock"] as Map<*, *>

        // then
        map["boot_id"] shouldBe "boot-1"
        map["clock_mapping_id"] shouldBe "cm-1"
        clock["boot_id"] shouldBe "boot-1"
        clock["clock_mapping_id"] shouldBe "cm-1"
    }

    @Test
    @DisplayName("봉투 상수와 모드 값은 최상위에 항상 들어간다")
    fun envelopeConstantsAreAlwaysPresent() {
        // when
        val map = batch.toMap()

        // then
        map["v"] shouldBe 2
        map["stream"] shouldBe "imu_watch"
        map["source"] shouldBe "watch"
        map["gyro_mode"] shouldBe "continuous"
        map["collection_mode"] shouldBe "product"
        map["watch_battery_pct"] shouldBe 63
    }
}
