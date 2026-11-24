package com.widucorp.widu.data.util

import io.kotest.matchers.shouldBe
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

@OptIn(ExperimentalCoroutinesApi::class)
class SendGateTest {
    @Test
    @DisplayName("마지막 신호 뒤 2.5초가 지나야 다음 신호를 보낸다")
    fun opensHalfABatchBeforeTheInterval() =
        runTest(UnconfinedTestDispatcher()) {
            // given
            var nowMs = 0L
            val gate = SendGate { nowMs }
            var ticks = 0
            backgroundScope.launch { gate.ticks.collect { ticks++ } }

            // when / then
            nowMs = 2_499
            gate.onData()
            ticks shouldBe 0

            nowMs = 2_500
            gate.onData()
            ticks shouldBe 1

            nowMs = 4_999
            gate.onData()
            ticks shouldBe 1

            nowMs = 5_000
            gate.onData()
            ticks shouldBe 2
        }
}
