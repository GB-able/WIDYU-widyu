package com.gbable.widu.data.repository

import com.gbable.widu.data.source.FallDetectionLocalDataSource
import com.gbable.widu.data.source.FallEventRemoteDataSource
import io.kotest.matchers.shouldBe
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class FallDetectionRepositoryImplTest {
    private lateinit var local: FakeLocalDataSource
    private lateinit var remote: FakeRemoteDataSource
    private lateinit var repository: FallDetectionRepository

    @BeforeEach
    fun setUp() {
        local = FakeLocalDataSource()
        remote = FakeRemoteDataSource()
        repository = FallDetectionRepositoryImpl(local, remote)
    }

    @Test
    @DisplayName("낙상 감지를 지원하면 리스너를 등록하고 true 를 반환한다")
    fun registersTheListenerWhenFallDetectionIsSupported() =
        runTest {
            // given
            local.hasCapability = true

            // when
            val isStarted = repository.startDetection()

            // then
            isStarted shouldBe true
            local.registerCount shouldBe 1
        }

    @Test
    @DisplayName("낙상 감지를 지원하지 않으면 리스너를 등록하지 않고 false 를 반환한다")
    fun doesNotRegisterTheListenerWhenFallDetectionIsUnsupported() =
        runTest {
            // given
            local.hasCapability = false

            // when
            val isStarted = repository.startDetection()

            // then
            isStarted shouldBe false
            local.registerCount shouldBe 0
        }

    @Test
    @DisplayName("낙상 이벤트를 원격 데이터 소스에 그대로 전달한다")
    fun forwardsTheFallEventToTheRemoteDataSource() {
        // when
        repository.sendFallEvent(1_700_000_000_000L)

        // then
        remote.sentEventTimes shouldBe listOf(1_700_000_000_000L)
    }

    private class FakeLocalDataSource : FallDetectionLocalDataSource {
        var hasCapability = true
        var registerCount = 0
        var unregisterCount = 0

        override suspend fun hasFallDetectionCapability(): Boolean = hasCapability

        override suspend fun registerFallListener() {
            registerCount += 1
        }

        override suspend fun unregisterFallListener() {
            unregisterCount += 1
        }
    }

    private class FakeRemoteDataSource : FallEventRemoteDataSource {
        val sentEventTimes = mutableListOf<Long>()

        override fun sendFallEvent(eventTimeEpochMs: Long) {
            sentEventTimes += eventTimeEpochMs
        }
    }
}
