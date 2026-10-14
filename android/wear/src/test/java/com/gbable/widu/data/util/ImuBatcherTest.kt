package com.gbable.widu.data.util

import com.gbable.widu.data.model.ImuSample
import io.kotest.matchers.nulls.shouldNotBeNull
import io.kotest.matchers.shouldBe
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class ImuBatcherTest {
    private val batchNs = 1_000_000_000L

    private fun acc(
        ts: Long,
        x: Float = 0f,
        y: Float = 0f,
        z: Float = 0f,
    ) = ImuSample(ImuSample.Type.ACC, ts, x, y, z)

    @Test
    @DisplayName("1초 경계를 넘는 샘플은 다음 배치의 첫 샘플이 되고 샘플을 버리지 않는다")
    fun boundarySampleStartsTheNextBatch() {
        // given
        val batcher = ImuBatcher(batchNs, 50)
        val timestamps = (0 until 75).map { it * 20_000_000L }

        // when
        val closed = timestamps.mapNotNull { batcher.add(acc(it)) }
        val remaining = batcher.flush()

        // then
        closed.size shouldBe 1
        closed[0].n shouldBe 50
        closed[0].t0ElapsedNs shouldBe 0L
        remaining.shouldNotBeNull()
        remaining.t0ElapsedNs shouldBe 1_000_000_000L
        closed[0].n + remaining.n shouldBe timestamps.size
    }

    @Test
    @DisplayName("dt_ns 는 길이 n-1 이고 실제 간격을 그대로 담는다")
    fun dtNsCarriesTheActualIntervals() {
        // given
        val batcher = ImuBatcher(batchNs, 50)
        val timestamps = listOf(0L, 19_998_417L, 40_001_422L, 60_003_421L)

        // when
        timestamps.forEach { batcher.add(acc(it)) }
        val series = batcher.flush()

        // then
        series.shouldNotBeNull()
        series.n shouldBe 4
        series.dtNs.size shouldBe series.n - 1
        series.dtNs.toList() shouldBe listOf(19_998_417L, 20_003_005L, 20_001_999L)
    }

    @Test
    @DisplayName("4.29초를 넘는 간격이 나오면 그 자리에서 배치를 나눈다")
    fun hugeGapSplitsTheBatch() {
        // given — 배치 길이가 아니라 간격 규칙으로 나뉘는지 보려고 배치 길이를 크게 잡는다
        val batcher = ImuBatcher(batchNs = Long.MAX_VALUE, fsHzRequested = 50)

        // when
        batcher.add(acc(0L))
        val closed = batcher.add(acc(4_294_967_296L))
        val remaining = batcher.flush()

        // then
        closed.shouldNotBeNull()
        closed.n shouldBe 1
        remaining.shouldNotBeNull()
        remaining.t0ElapsedNs shouldBe 4_294_967_296L
    }

    @Test
    @DisplayName("가속도 m/s² 를 mg 정수로 변환한다")
    fun convertsAccelerationToMilliG() {
        // given
        val batcher = ImuBatcher(batchNs, 50)

        // when
        batcher.add(acc(0L, x = 9.80665f, y = -9.80665f, z = 0f))
        val series = batcher.flush()

        // then
        series.shouldNotBeNull()
        series.values[0].toList() shouldBe listOf(1000, -1000, 0)
    }

    @Test
    @DisplayName("flush 는 남은 샘플을 반환하고 비운 뒤에는 null 을 반환한다")
    fun flushReturnsRemainingSamplesOnce() {
        // given
        val batcher = ImuBatcher(batchNs, 50)
        batcher.add(acc(0L))
        batcher.add(acc(20_000_000L))

        // when
        val first = batcher.flush()
        val second = batcher.flush()

        // then
        first.shouldNotBeNull()
        first.n shouldBe 2
        second shouldBe null
    }
}
