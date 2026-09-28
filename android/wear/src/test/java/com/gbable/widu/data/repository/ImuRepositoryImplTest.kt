package com.gbable.widu.data.repository

import com.gbable.widu.data.model.ClockAnchor
import com.gbable.widu.data.model.ImuBatch
import com.gbable.widu.data.model.ImuConfig
import com.gbable.widu.data.model.ImuSample
import com.gbable.widu.data.source.ClockLocalDataSource
import com.gbable.widu.data.source.DeviceInfoLocalDataSource
import com.gbable.widu.data.source.ImuLocalDataSource
import com.gbable.widu.data.source.ImuRemoteDataSource
import io.kotest.matchers.shouldBe
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
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
class ImuRepositoryImplTest {
    private lateinit var local: FakeImuLocalDataSource
    private lateinit var remote: FakeImuRemoteDataSource
    private lateinit var repository: ImuRepository
    private lateinit var scheduler: TestCoroutineScheduler
    private lateinit var dispatcher: TestDispatcher
    private lateinit var testScope: TestScope
    private lateinit var collector: Job
    private val collected = mutableListOf<ImuBatch>()

    @BeforeEach
    fun setUp() {
        scheduler = TestCoroutineScheduler()
        dispatcher = StandardTestDispatcher(scheduler)
        testScope = TestScope(dispatcher)
        local = FakeImuLocalDataSource()
        remote = FakeImuRemoteDataSource()
        collected.clear()
        repository =
            ImuRepositoryImpl(
                imuLocalDataSource = local,
                clockLocalDataSource = FakeClockLocalDataSource(),
                deviceInfoLocalDataSource = FakeDeviceInfoLocalDataSource(),
                imuRemoteDataSource = remote,
                config = ImuConfig(batchSec = 1, trimEverySeq = 2, queueMinutes = 10),
                ioDispatcher = dispatcher,
            )
        collector = testScope.backgroundScope.launch { repository.batches().collect { collected += it } }
        scheduler.runCurrent()
    }

    @AfterEach
    fun tearDown() {
        collector.cancel()
        scheduler.runCurrent()
    }

    @Test
    @DisplayName("1초치 샘플이 모이면 배치를 내보내고 같은 배치를 폰으로 전송한다")
    fun emitsABatchAndSendsIt() =
        testScope.runTest {
            // when
            emitSamplesUpTo(seconds = 1)

            // then
            collected.size shouldBe 1
            remote.sentBatches shouldBe collected
        }

    @Test
    @DisplayName("trimEverySeq 배수의 seq 마다 큐 정리를 호출한다")
    fun trimsTheQueueEveryConfiguredSeq() =
        testScope.runTest {
            // when — seq 0..3 네 배치
            emitSamplesUpTo(seconds = 4)

            // then — seq 0, 2 에서만 정리한다
            collected.map { it.seq } shouldBe listOf(0L, 1L, 2L, 3L)
            remote.trimmedSeqs shouldBe listOf(0L, 2L)
            remote.trimmedMaxItems shouldBe listOf(600, 600)
        }

    @Test
    @DisplayName("큐 정리로 배치를 버리면 버린 구간을 기록한다")
    fun recordsTheDroppedRange() =
        testScope.runTest {
            // given
            remote.dropOnTrim = listOf(3L, 4L, 5L)

            // when
            emitSamplesUpTo(seconds = 1)

            // then
            remote.droppedRanges shouldBe listOf(Triple(collected.first().sessionId, 3L, 5L))
        }

    @Test
    @DisplayName("전송이 실패해도 다음 배치를 계속 내보낸다")
    fun aFailedSendDoesNotStopTheStream() =
        testScope.runTest {
            // given
            remote.failSend = true

            // when
            emitSamplesUpTo(seconds = 3)

            // then
            collected.map { it.seq } shouldBe listOf(0L, 1L, 2L)
            remote.sentBatches shouldBe emptyList()
        }

    /** [seconds] 개의 배치가 닫히도록 1초 간격 샘플을 흘린다. */
    private suspend fun emitSamplesUpTo(seconds: Int) {
        repeat(seconds + 1) { index ->
            local.samples.emit(
                ImuSample(ImuSample.Type.ACC, index * ONE_SECOND_NS, 0f, 0f, 9.80665f),
            )
            scheduler.runCurrent()
        }
    }

    private class FakeImuLocalDataSource : ImuLocalDataSource {
        val samples = MutableSharedFlow<ImuSample>()

        override fun samples(): Flow<ImuSample> = samples
    }

    private class FakeClockLocalDataSource : ClockLocalDataSource {
        override fun bootId(): String = "boot"

        override fun takeAnchor(): ClockAnchor = ClockAnchor(elapsedNs = 0L, epochMs = 1_700_000_000_000L, uncertaintyMs = 1.0)
    }

    private class FakeDeviceInfoLocalDataSource : DeviceInfoLocalDataSource {
        override fun deviceId(): String = "gw-test"

        override fun batteryPercent(): Int = 77

        override fun openRawLog(): BufferedWriter? = null
    }

    private class FakeImuRemoteDataSource : ImuRemoteDataSource {
        val sentBatches = mutableListOf<ImuBatch>()
        val trimmedSeqs = mutableListOf<Long>()
        val trimmedMaxItems = mutableListOf<Int>()
        val droppedRanges = mutableListOf<Triple<String, Long, Long>>()
        var dropOnTrim: List<Long> = emptyList()
        var failSend = false

        override suspend fun sendBatch(batch: ImuBatch) {
            if (failSend) throw IllegalStateException("Disconnected")
            sentBatches += batch
        }

        override suspend fun trimQueue(
            sessionId: String,
            maxItems: Int,
        ): List<Long> {
            trimmedSeqs += sentBatches.last().seq
            trimmedMaxItems += maxItems
            return dropOnTrim
        }

        override suspend fun recordDrop(
            sessionId: String,
            fromSeq: Long,
            toSeq: Long,
        ) {
            droppedRanges += Triple(sessionId, fromSeq, toSeq)
        }
    }

    private companion object {
        const val ONE_SECOND_NS = 1_000_000_000L
    }
}
