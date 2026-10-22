package com.widucorp.widu.data.repository

import com.widucorp.widu.data.model.ClockAnchor
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.HIGH
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.LOW
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.UNKNOWN
import com.widucorp.widu.data.model.HeartRateAccuracyLabel.UNRELIABLE
import com.widucorp.widu.data.model.HeartRateBatch
import com.widucorp.widu.data.model.HeartRateReading
import com.widucorp.widu.data.model.HeartRateSample
import com.widucorp.widu.data.model.HeartRateStatus
import com.widucorp.widu.data.model.MeasureResult
import com.widucorp.widu.data.source.ClockLocalDataSource
import com.widucorp.widu.data.source.DeviceInfoLocalDataSource
import com.widucorp.widu.data.source.HeartRateLocalDataSource
import com.widucorp.widu.data.source.HeartRateRemoteDataSource
import com.widucorp.widu.data.util.OnBodyStateHolder
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
import kotlinx.coroutines.test.advanceTimeBy
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

    @Test
    @DisplayName("센서 묶음 하나를 샘플 전부와 각자의 잰 시각·정확도로 배치 하나에 담아 보낸다")
    fun sendsEverySampleOfOneUpdateAsOneBatch() =
        testScope.runTest {
            // when — 정확도가 낮은 샘플도 섞여 있다
            emit(70, reading(71, 1_000, HIGH), reading(72, 2_000, LOW), reading(73, 3_000, UNKNOWN))

            // then
            val batch = remote.sentBatches.single()
            batch.samples shouldBe
                listOf(
                    HeartRateSample(71, EPOCH_MS + 1_000, HIGH),
                    HeartRateSample(72, EPOCH_MS + 2_000, LOW),
                    HeartRateSample(73, EPOCH_MS + 3_000, UNKNOWN),
                )
            batch.seq shouldBe 0L
            batch.batchId.length shouldBe 26
            batch.deviceId shouldBe "gw-test"
            batch.watchBatteryPct shouldBe 77
        }

    @Test
    @DisplayName("새 묶음이 없으면 시간이 지나도 최근 값을 다시 보내지 않는다")
    fun doesNotResendTheLatestValueOnATimer() =
        testScope.runTest {
            // given
            emit(70, reading(70, 1_000, HIGH))

            // when
            advanceTimeBy(10_000)
            runCurrent()

            // then
            remote.sentBatches.size shouldBe 1
            remote.sentHeartRates shouldBe listOf(70)
        }

    @Test
    @DisplayName("bpm 이 0 이거나 0~300 밖이면 버리지 않고 0/UNRELIABLE 로 보낸다")
    fun outOfRangeBpmIsSentAsUnreliableZero() =
        testScope.runTest {
            // when
            emit(null, reading(0, 1_000, HIGH), reading(350, 2_000, MEDIUM_LABEL))

            // then
            remote.sentBatches.single().samples shouldBe
                listOf(
                    HeartRateSample(0, EPOCH_MS + 1_000, UNRELIABLE),
                    HeartRateSample(0, EPOCH_MS + 2_000, UNRELIABLE),
                )
        }

    @Test
    @DisplayName("같은 ms 로 겹치는 샘플은 나중 것만 남겨 배치 안의 시각이 엄격히 증가한다")
    fun samplesSharingAMillisecondKeepTheLaterOne() =
        testScope.runTest {
            // when — 순서도 섞여 온다
            emit(null, reading(82, 2_000, HIGH), reading(80, 1_000, HIGH), reading(81, 1_000, LOW))

            // then
            remote.sentBatches.single().samples.map { it.bpm to it.tsMs } shouldBe
                listOf(81 to EPOCH_MS + 1_000, 82 to EPOCH_MS + 2_000)
        }

    @Test
    @DisplayName("샘플이 60개를 넘으면 배치를 나누고 seq 를 이어 붙인다")
    fun splitsAtSixtySamples() =
        testScope.runTest {
            // when
            emit(null, *Array(61) { reading(70, (it + 1) * 1_000L, HIGH) })

            // then
            remote.sentBatches.map { it.samples.size } shouldBe listOf(60, 1)
            remote.sentBatches.map { it.seq } shouldBe listOf(0L, 1L)
        }

    @Test
    @DisplayName("화면에 쓸 값이 없는 묶음도 샘플은 보내고 화면 값은 보내지 않는다")
    fun sendsSamplesEvenWithoutADisplayValue() =
        testScope.runTest {
            // when
            emit(null, reading(40, 1_000, UNRELIABLE))

            // then
            remote.sentBatches.single().samples.single().accuracy shouldBe UNRELIABLE
            remote.sentHeartRates shouldBe emptyList()
        }

    @Test
    @DisplayName("착용 여부를 모르면 true, 몸에서 떨어졌다고 알렸으면 false 로 싣는다")
    fun onBodyFollowsTheHolder() =
        testScope.runTest {
            // when — 아직 모른다
            emit(70, reading(70, 1_000, HIGH))
            // and — 몸에서 떨어졌다
            local.events.emit(MeasureResult.Availability(isAvailable = false, isOnBody = false))
            runCurrent()
            emit(null, reading(0, 2_000, UNRELIABLE))

            // then
            remote.sentBatches.map { it.onBody } shouldBe listOf(true, false)
            onBodyStateHolder.state.value shouldBe false
        }

    @Test
    @DisplayName("배치 전송이 실패해도 측정을 멈추지 않고 다음 묶음을 보낸다")
    fun aFailedSendDoesNotStopMeasurement() =
        testScope.runTest {
            // given
            remote.failuresBeforeSuccess = 1

            // when
            emit(70, reading(70, 1_000, HIGH))
            emit(71, reading(71, 2_000, HIGH))

            // then
            remote.sentBatches.map { it.seq } shouldBe listOf(1L)
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
        var failuresBeforeSuccess = 0
        val sentBatches = mutableListOf<HeartRateBatch>()
        val sentHeartRates = mutableListOf<Int>()

        override fun sendHeartRate(heartRate: Int) {
            sentHeartRates += heartRate
        }

        override suspend fun sendBatch(batch: HeartRateBatch) {
            if (failuresBeforeSuccess > 0) {
                failuresBeforeSuccess -= 1
                throw IllegalStateException("Temporary failure")
            }
            sentBatches += batch
        }

        override suspend fun trimQueue(
            sessionId: String,
            maxItems: Int,
        ): List<Long> = emptyList()

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
        const val MEDIUM_LABEL = "MEDIUM"
    }
}
