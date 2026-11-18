package com.widucorp.widu.data.repository

import com.widucorp.widu.data.model.ClockAnchor
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.HIGH
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.LOW
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.UNRELIABLE
import com.widucorp.widu.data.model.HeartRateBatch
import com.widucorp.widu.data.model.HeartRateReading
import com.widucorp.widu.data.model.HeartRateStatus
import com.widucorp.widu.data.model.MeasureResult
import com.widucorp.widu.data.source.ClockLocalDataSource
import com.widucorp.widu.data.source.DeviceInfoLocalDataSource
import com.widucorp.widu.data.source.HeartRateLocalDataSource
import com.widucorp.widu.data.source.HeartRateRemoteDataSource
import com.widucorp.widu.data.util.OnBodyStateHolder
import com.widucorp.widu.data.util.SendGate
import io.kotest.matchers.shouldBe
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.emptyFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.TestCoroutineScheduler
import kotlinx.coroutines.test.TestDispatcher
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.runCurrent
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import java.io.BufferedWriter

@OptIn(ExperimentalCoroutinesApi::class)
class HeartRateRepositoryImplTest {
    private lateinit var local: FakeLocalDataSource
    private lateinit var remote: FakeRemoteDataSource
    private lateinit var repository: HeartRateRepository
    private lateinit var onBodyStateHolder: OnBodyStateHolder
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
        onBodyStateHolder = OnBodyStateHolder()
        repository =
            HeartRateRepositoryImpl(
                heartRateLocalDataSource = local,
                heartRateRemoteDataSource = remote,
                clockLocalDataSource = FakeClockLocalDataSource(),
                deviceInfoLocalDataSource = FakeDeviceInfoLocalDataSource(),
                onBodyStateHolder = onBodyStateHolder,
                sendGate = SendGate(),
                ioDispatcher = dispatcher,
                applicationScope = appScope,
            )
        collector = appScope.launch { repository.getHeartRate().collect() }
        scheduler.runCurrent()
    }

    @AfterEach
    fun tearDown() {
        collector.cancel()
        appScope.cancel()
        scheduler.runCurrent()
    }

    // 배치 전송은 SendGate 가 실제 경과 시간으로 열어 단위 테스트에서는 일어나지 않는다. 전송 주기·배치 내용은 실기기로 확인한다.
    // 샘플 변환 규칙은 HeartRateSamplesTest 가 확인한다.

    @Test
    @DisplayName("몸에서 떨어졌다고 알리면 착용 상태를 false 로 바꾼다")
    fun offBodyAvailabilityUpdatesTheHolder() =
        testScope.runTest {
            // given
            emit(70, reading(70, 1_000, HIGH))
            onBodyStateHolder.state.value shouldBe true

            // when
            local.events.emit(MeasureResult.Availability(isAvailable = false, isOnBody = false))
            runCurrent()

            // then
            onBodyStateHolder.state.value shouldBe false
        }

    @Test
    @DisplayName("몸에서 떨어졌다고 알린 뒤 믿을 만한 심박이 다시 오면 착용으로 되돌린다")
    fun reliableHeartRateAfterOffBodyRestoresOnBody() =
        testScope.runTest {
            // given — 몸에서 떨어졌다
            local.events.emit(MeasureResult.Availability(isAvailable = false, isOnBody = false))
            runCurrent()

            // when — AVAILABLE 콜백 없이 믿을 만한 심박이 다시 온다
            emit(72, reading(72, 1_000, HIGH))

            // then
            onBodyStateHolder.state.value shouldBe true
        }

    @Test
    @DisplayName("몸에서 떨어진 뒤 믿을 수 없는 심박만 오면 착용으로 바꾸지 않는다")
    fun unreliableHeartRateAfterOffBodyKeepsOffBody() =
        testScope.runTest {
            // given
            local.events.emit(MeasureResult.Availability(isAvailable = false, isOnBody = false))
            runCurrent()

            // when
            emit(null, reading(0, 1_000, UNRELIABLE))

            // then
            onBodyStateHolder.state.value shouldBe false
        }

    @Test
    @DisplayName("차고 있는데 이번 묶음의 마지막 정확도가 LOW 면 전송을 기다리지 않고 WORN_INVALID 로 본다")
    fun lowAccuracyWhileWornIsWornInvalid() =
        testScope.runTest {
            // given
            onBodyStateHolder.update(true)

            // when
            emit(null, reading(25, 1_000, HIGH), reading(25, 2_000, LOW))

            // then
            onBodyStateHolder.wearState(true) shouldBe "WORN_INVALID"
        }

    @Test
    @DisplayName("도착 순서가 뒤섞여도 측정 시각이 가장 늦은 샘플의 정확도로 판정한다")
    fun latestMeasuredReadingDecidesWearState() =
        testScope.runTest {
            // given
            onBodyStateHolder.update(true)

            // when — 목록 마지막은 HIGH 지만 측정 시각은 더 이르다
            emit(null, reading(25, 2_000, LOW), reading(70, 1_000, HIGH))

            // then
            onBodyStateHolder.wearState(true) shouldBe "WORN_INVALID"
        }

    @Test
    @DisplayName("범위 밖 bpm 은 정확도가 HIGH 여도 UNRELIABLE 이므로 WORN_INVALID 다")
    fun outOfRangeBpmIsWornInvalid() =
        testScope.runTest {
            // given
            onBodyStateHolder.update(true)

            // when
            emit(null, reading(400, 1_000, HIGH))

            // then
            onBodyStateHolder.wearState(true) shouldBe "WORN_INVALID"
        }

    private suspend fun emit(
        value: Int?,
        vararg readings: HeartRateReading,
    ) {
        local.events.emit(MeasureResult.HeartRate(value, readings.toList()))
        scheduler.runCurrent()
    }

    private fun reading(
        bpm: Int,
        elapsedMs: Long,
        accuracy: String,
    ) = HeartRateReading(bpm = bpm, elapsedNs = elapsedMs * 1_000_000L, accuracy = accuracy)

    private class FakeLocalDataSource : HeartRateLocalDataSource {
        val events = MutableSharedFlow<MeasureResult>()

        override suspend fun hasHeartRateCapability(): Boolean = true

        override fun getMeasureResult(): Flow<MeasureResult> = events

        override suspend fun restartSession() = Unit
    }

    private class FakeRemoteDataSource : HeartRateRemoteDataSource {
        override suspend fun sendBatch(batch: HeartRateBatch): Boolean = true

        override suspend fun trimQueue(
            sessionId: String,
            maxItems: Int,
        ): List<Long> = emptyList()

        override suspend fun recordDrop(
            sessionId: String,
            fromSeq: Long,
            toSeq: Long,
            reason: String,
        ) = Unit

        override fun fetchHeartRateStatus(): Flow<HeartRateStatus> = emptyFlow()
    }

    private class FakeClockLocalDataSource : ClockLocalDataSource {
        override fun bootId(): String = "boot"

        override fun takeAnchor(): ClockAnchor = ClockAnchor(elapsedNs = 0L, epochMs = EPOCH_MS, uncertaintyMs = 1.0)
    }

    private class FakeDeviceInfoLocalDataSource : DeviceInfoLocalDataSource {
        override fun deviceId(): String = "gw-test"

        override fun batteryPercent(): Int = 77

        override fun openRawLog(): BufferedWriter? = null
    }

    private companion object {
        const val EPOCH_MS = 1_700_000_000_000L
    }
}
