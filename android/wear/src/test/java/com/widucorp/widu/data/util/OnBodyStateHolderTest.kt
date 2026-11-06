package com.widucorp.widu.data.util

import io.kotest.matchers.shouldBe
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class OnBodyStateHolderTest {
    private val holder = OnBodyStateHolder()

    @Test
    @DisplayName("착용 여부와 최근 심박 정확도로 wear_state 를 정한다")
    fun wearStateFollowsOnBodyAndAccuracy() {
        holder.wearState() shouldBe WearState.UNKNOWN

        holder.update(true)
        holder.wearState() shouldBe WearState.WORN_INVALID

        listOf("LOW", "UNRELIABLE", "UNKNOWN").forEach {
            holder.updateHeartRateAccuracy(it)
            holder.wearState() shouldBe WearState.WORN_INVALID
        }
        listOf("HIGH", "MEDIUM").forEach {
            holder.updateHeartRateAccuracy(it)
            holder.wearState() shouldBe WearState.WORN_VALID
        }

        holder.update(false)
        holder.wearState() shouldBe WearState.ACTUAL_NOT_WORN
    }

    @Test
    @DisplayName("벗었다 다시 차면 새 심박이 오기 전까지 WORN_INVALID 다")
    fun rewearIsInvalidUntilNextHeartRate() {
        holder.update(true)
        holder.updateHeartRateAccuracy("HIGH")

        holder.update(false)
        holder.update(true)
        holder.wearState() shouldBe WearState.WORN_INVALID

        holder.updateHeartRateAccuracy("HIGH")
        holder.wearState() shouldBe WearState.WORN_VALID
    }
}
