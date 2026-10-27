package com.widucorp.widu.data.util

import com.widucorp.widu.data.model.ClockInfo
import com.widucorp.widu.data.model.HeartRateBatch
import com.widucorp.widu.data.model.HeartRateSample
import io.kotest.matchers.shouldBe
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

/** org.json 은 JVM 단위 테스트에서 스텁이라 봉투 형식은 [HeartRateBatch.toMap] 에서 검증한다. */
class HeartRateBatchTest {
    private val batch =
        HeartRateBatch(
            batchId = "01j8zk3v9x2q4m7n8p1r5s6t7v",
            deviceId = "gw-3f2a",
            sessionId = "s-01",
            seq = 0L,
            clock =
                ClockInfo(
                    bootId = "boot-01",
                    clockMappingId = "cm-01",
                    anchorElapsedNs = 1_000_000_000L,
                    anchorEpochMs = 1_760_000_000_000L,
                    uncertaintyMs = 2.0,
                ),
            samples = listOf(HeartRateSample(82, 1_760_000_000_000L, "UNKNOWN"), HeartRateSample(83, 1_760_000_001_000L, "HIGH")),
            onBody = true,
            watchBatteryPct = 63,
        )

    @Test
    @DisplayName("서버 심박 스펙의 키만 싣는다 — IMU 전용 필드와 memberId 는 없다")
    fun carriesOnlyTheHeartRateSpecKeys() {
        // when
        val map = batch.toMap()

        // then
        map.keys shouldBe
            setOf(
                "v", "stream", "batch_id", "device_id", "session_id", "seq", "study_id", "participation_id", "run_id",
                "clock", "samples", "on_body", "watch_battery_pct", "resend",
            )
        map["v"] shouldBe 2
        map["stream"] shouldBe "hr"
        map["resend"] shouldBe null
    }

    @Test
    @DisplayName("기준점 나노초는 10진 문자열, 샘플은 bpm·ts_ms·accuracy 를 모두 싣는다")
    fun clockAndSampleShapes() {
        // when
        val map = batch.toMap()

        // then
        (map["clock"] as Map<*, *>)["anchor_elapsed_ns"] shouldBe "1000000000"
        map["samples"] shouldBe
            listOf(
                mapOf("bpm" to 82, "ts_ms" to 1_760_000_000_000L, "accuracy" to "UNKNOWN"),
                mapOf("bpm" to 83, "ts_ms" to 1_760_000_001_000L, "accuracy" to "HIGH"),
            )
    }
}
