package com.example.widyu.data.repository

import com.example.widyu.data.model.HeartRateStatus
import com.example.widyu.data.model.MeasureResult
import com.example.widyu.data.source.HeartRateLocalDataSource
import com.example.widyu.data.source.HeartRateRemoteDataSource
import io.kotest.matchers.shouldBe
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.emptyFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestCoroutineScheduler
import kotlinx.coroutines.test.TestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.runCurrent
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

@OptIn(ExperimentalCoroutinesApi::class)
class HeartRateRepositoryImplTest {
    private lateinit var local: FakeLocalDataSource
    private lateinit var remote: FakeRemoteDataSource
    private lateinit var repository: HeartRateRepository
    private lateinit var appScope: CoroutineScope
    private lateinit var collector: Job
    private lateinit var scheduler: TestCoroutineScheduler
    private lateinit var dispatcher: TestDispatcher
    private lateinit var testScope: TestScope

    @BeforeEach
    fun setUp() {
        scheduler = TestCoroutineScheduler()
        dispatcher = StandardTestDispatcher(scheduler)
        testScope = TestScope(dispatcher)
        local = FakeLocalDataSource()
        remote = FakeRemoteDataSource()
        appScope = testScope.backgroundScope
        repository = HeartRateRepositoryImpl(local, remote, dispatcher, appScope)
        collector = appScope.launch { repository.getHeartRate().collect() }
        scheduler.runCurrent()
    }

    @AfterEach
    fun tearDown() {
        collector.cancel()
        appScope.cancel()
        scheduler.runCurrent()
    }

    @Test
    @DisplayName("첫 심박수를 수신하기 전에는 시간이 지나도 전송하지 않는다")
    fun doesNotSendBeforeTheFirstHeartRate() =
        testScope.runTest {
            // when
            advanceTimeBy(3_000)
            runCurrent()

            // then
            remote.sentHeartRates shouldBe emptyList()
        }

    @Test
    @DisplayName("1초마다 가장 최근에 수신한 심박수를 전송한다")
    fun sendsTheLatestReceivedHeartRateAtEachOneSecondTick() =
        testScope.runTest {
            // when
            local.events.emit(MeasureResult.HeartRate(60))
            advanceTimeBy(1_000)
            runCurrent()
            local.events.emit(MeasureResult.HeartRate(61))
            local.events.emit(MeasureResult.HeartRate(62))
            advanceTimeBy(1_000)
            runCurrent()

            // then
            remote.sentHeartRates shouldBe listOf(60, 62)
        }

    @Test
    @DisplayName("심박수가 연속으로 갱신되어도 기존 1초 전송 주기를 유지한다")
    fun rapidHeartRateUpdatesDoNotMoveTheNextSendTick() =
        testScope.runTest {
            // when
            local.events.emit(MeasureResult.HeartRate(70))
            advanceTimeBy(500)
            runCurrent()
            local.events.emit(MeasureResult.HeartRate(71))
            advanceTimeBy(499)
            runCurrent()
            val sentBeforeTick = remote.sentHeartRates.toList()
            advanceTimeBy(1)
            runCurrent()

            // then
            sentBeforeTick shouldBe emptyList()
            remote.sentHeartRates shouldBe listOf(71)
        }

    @Test
    @DisplayName("운동 세션이 대체되면 저장된 심박수의 전송을 중단한다")
    fun supersededSessionClearsTheCachedHeartRate() =
        testScope.runTest {
            local.events.emit(MeasureResult.HeartRate(80))
            advanceTimeBy(1_000)
            runCurrent()

            // when
            local.events.emit(MeasureResult.SessionSuperseded)
            advanceTimeBy(1_000)
            runCurrent()

            // then
            remote.sentHeartRates shouldBe listOf(80)
        }

    @Test
    @DisplayName("여러 구독자가 있어도 측정 구독과 주기별 전송은 한 번만 수행한다")
    fun multipleSubscribersShareOneMeasurementSubscription() =
        testScope.runTest {
            // given
            appScope.launch { repository.getHeartRate().collect() }
            runCurrent()

            // when
            local.events.emit(MeasureResult.HeartRate(85))
            advanceTimeBy(1_000)
            runCurrent()

            // then
            local.activeSubscriptions shouldBe 1
            remote.sentHeartRates shouldBe listOf(85)
        }

    @Test
    @DisplayName("애플리케이션 스코프가 취소되면 주기 전송을 중단한다")
    fun cancellingApplicationScopeStopsPeriodicSending() =
        testScope.runTest {
            // given
            local.events.emit(MeasureResult.HeartRate(90))
            advanceTimeBy(1_000)
            runCurrent()

            // when
            appScope.cancel()
            advanceTimeBy(2_000)
            runCurrent()

            // then
            remote.sentHeartRates shouldBe listOf(90)
        }

    @Test
    @DisplayName("전송에 실패해도 다음 1초 주기에 다시 전송한다")
    fun aFailedSendDoesNotStopTheNextTick() =
        testScope.runTest {
            // given
            remote.failuresBeforeSuccess = 1
            local.events.emit(MeasureResult.HeartRate(100))

            // when
            advanceTimeBy(2_000)
            runCurrent()

            // then
            remote.sentHeartRates shouldBe listOf(100)
        }

    @Test
    @DisplayName("측정이 불가능해져도 마지막 심박수를 1초마다 반복 전송한다")
    fun repeatsTheCachedHeartRateAndKeepsItWhenAvailabilityChanges() =
        testScope.runTest {
            local.events.emit(MeasureResult.HeartRate(110))
            advanceTimeBy(1_000)
            runCurrent()

            // when
            local.events.emit(MeasureResult.Availability(isAvailable = false))
            advanceTimeBy(1_000)
            runCurrent()

            // then
            remote.sentHeartRates shouldBe listOf(110, 110)
        }

    private class FakeLocalDataSource : HeartRateLocalDataSource {
        val events = MutableSharedFlow<MeasureResult>()
        var activeSubscriptions = 0

        override suspend fun hasHeartRateCapability(): Boolean = true

        override fun getMeasureResult(): Flow<MeasureResult> =
            flow {
                activeSubscriptions += 1
                try {
                    events.collect { emit(it) }
                } finally {
                    activeSubscriptions -= 1
                }
            }

        override suspend fun restartSession() = Unit
    }

    private class FakeRemoteDataSource(
        var failuresBeforeSuccess: Int = 0,
    ) : HeartRateRemoteDataSource {
        val sentHeartRates = mutableListOf<Int>()

        override fun sendHeartRate(heartRate: Int) {
            if (failuresBeforeSuccess > 0) {
                failuresBeforeSuccess -= 1
                throw IllegalStateException("Temporary failure")
            }
            sentHeartRates += heartRate
        }

        override fun fetchHeartRateStatus(): Flow<HeartRateStatus> = emptyFlow()
    }
}
