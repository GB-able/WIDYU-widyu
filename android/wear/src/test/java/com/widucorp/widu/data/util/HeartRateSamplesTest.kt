package com.widucorp.widu.data.util

import com.widucorp.widu.data.model.ClockInfo
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.HIGH
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.LOW
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.UNKNOWN
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.UNRELIABLE
import com.widucorp.widu.data.model.HeartRateReading
import com.widucorp.widu.data.model.HeartRateSample
import io.kotest.matchers.shouldBe
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class HeartRateSamplesTest {
    @Test
    @DisplayName("센서 묶음의 샘플 전부를 각자의 잰 시각·정확도로 싣는다")
    fun keepsEverySampleWithItsOwnTimeAndAccuracy() {
        listOf(reading(71, 1_000, HIGH), reading(72, 2_000, LOW), reading(73, 3_000, UNKNOWN)).toBatchSamples(CLOCK) shouldBe
            listOf(
                listOf(
                    HeartRateSample(71, EPOCH_MS + 1_000, HIGH),
                    HeartRateSample(72, EPOCH_MS + 2_000, LOW),
                    HeartRateSample(73, EPOCH_MS + 3_000, UNKNOWN),
                ),
            )
    }

    @Test
    @DisplayName("bpm 이 0 이거나 0~300 밖이면 버리지 않고 0/UNRELIABLE 로 보낸다")
    fun outOfRangeBpmIsUnreliableZero() {
        listOf(reading(0, 1_000, HIGH), reading(350, 2_000, "MEDIUM")).toBatchSamples(CLOCK).single() shouldBe
            listOf(
                HeartRateSample(0, EPOCH_MS + 1_000, UNRELIABLE),
                HeartRateSample(0, EPOCH_MS + 2_000, UNRELIABLE),
            )
    }

    @Test
    @DisplayName("같은 ms 로 겹치는 샘플은 나중 것만 남겨 시각이 엄격히 증가한다")
    fun samplesSharingAMillisecondKeepTheLaterOne() {
        listOf(reading(82, 2_000, HIGH), reading(80, 1_000, HIGH), reading(81, 1_000, LOW))
            .toBatchSamples(CLOCK)
            .single()
            .map { it.bpm to it.tsMs } shouldBe listOf(81 to EPOCH_MS + 1_000, 82 to EPOCH_MS + 2_000)
    }

    @Test
    @DisplayName("샘플이 60개를 넘으면 배치를 나눈다")
    fun splitsAtSixtySamples() {
        List(61) { reading(70, (it + 1) * 1_000L, HIGH) }.toBatchSamples(CLOCK).map { it.size } shouldBe listOf(60, 1)
    }

    private fun reading(
        bpm: Int,
        elapsedMs: Long,
        accuracy: String,
    ) = HeartRateReading(bpm = bpm, elapsedNs = elapsedMs * 1_000_000L, accuracy = accuracy)

    private companion object {
        const val EPOCH_MS = 1_700_000_000_000L
        val CLOCK = ClockInfo("boot", "cm", anchorElapsedNs = 0L, anchorEpochMs = EPOCH_MS, uncertaintyMs = 1.0)
    }
}
