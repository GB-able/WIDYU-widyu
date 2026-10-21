package com.widucorp.widu.data.util

import com.widucorp.widu.data.model.ImuSample
import io.kotest.matchers.doubles.plusOrMinus
import io.kotest.matchers.nulls.shouldBeNull
import io.kotest.matchers.shouldBe
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class ImpactDetectorTest {
    private val detector = ImpactDetector(impactG = 1.8f)

    @Test
    @DisplayName("SMV 가 문턱값 이상이면 그때의 g 값을 돌려준다")
    fun reportsSmvAtOrAboveTheThreshold() {
        // when
        val smvG = detector.check(accAt(z = 1.8f * STANDARD_GRAVITY))

        // then
        smvG!!.toDouble() shouldBe (1.8 plusOrMinus 1e-4)
    }

    @Test
    @DisplayName("문턱값보다 작으면 충격이 아니다")
    fun ignoresSmvBelowTheThreshold() {
        detector.check(accAt(z = 1.79f * STANDARD_GRAVITY)).shouldBeNull()
        detector.check(accAt(z = STANDARD_GRAVITY)).shouldBeNull()
    }

    @Test
    @DisplayName("세 축을 합쳐 크기를 잰다")
    fun combinesAllThreeAxes() {
        // given — 세 축이 각각 1.2g 면 크기는 약 2.08g
        val perAxis = 1.2f * STANDARD_GRAVITY

        // then
        detector.check(ImuSample(ImuSample.Type.ACC, 0L, perAxis, perAxis, perAxis))!!
            .toDouble() shouldBe (2.0785 plusOrMinus 1e-3)
    }

    @Test
    @DisplayName("자이로 샘플로는 충격을 재지 않는다")
    fun neverTriggersOnGyroSamples() {
        detector.check(ImuSample(ImuSample.Type.GYRO, 0L, 100f, 100f, 100f)).shouldBeNull()
    }

    private fun accAt(z: Float) = ImuSample(ImuSample.Type.ACC, 0L, 0f, 0f, z)

    private companion object {
        const val STANDARD_GRAVITY = 9.80665f
    }
}
