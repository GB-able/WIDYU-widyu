package com.widucorp.widu.data.repository

import com.widucorp.widu.data.model.ClockAnchor
import com.widucorp.widu.data.model.ImuBatch
import com.widucorp.widu.data.model.ImuConfig
import com.widucorp.widu.data.model.ImuSample
import com.widucorp.widu.data.source.ClockLocalDataSource
import com.widucorp.widu.data.source.DeviceInfoLocalDataSource
import com.widucorp.widu.data.source.ImuConfigLocalDataSource
import com.widucorp.widu.data.source.ImuLocalDataSource
import com.widucorp.widu.data.source.ImuRemoteDataSource
import com.widucorp.widu.data.util.OnBodyStateHolder
import com.widucorp.widu.data.util.SendGate
import io.kotest.matchers.shouldBe
import io.kotest.matchers.shouldNotBe
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.onCompletion
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
    private lateinit var configSource: FakeImuConfigLocalDataSource
    private lateinit var remote: FakeImuRemoteDataSource
    private lateinit var repository: ImuRepository
    private lateinit var onBodyStateHolder: OnBodyStateHolder
    private lateinit var scheduler: TestCoroutineScheduler
    private lateinit var dispatcher: TestDispatcher
    private lateinit var testScope: TestScope
    private lateinit var collector: Job
    private val collected = mutableListOf<ImuBatch>()

    /** [SendGate] 가 읽는 경과 시간(ms). 올리지 않으면 게이트가 열리지 않는다. */
    private var nowMs = 0L

    @BeforeEach
    fun setUp() {
        scheduler = TestCoroutineScheduler()
        dispatcher = StandardTestDispatcher(scheduler)
        testScope = TestScope(dispatcher)
        local = FakeImuLocalDataSource()
        configSource = FakeImuConfigLocalDataSource()
        remote = FakeImuRemoteDataSource()
        onBodyStateHolder = OnBodyStateHolder()
        collected.clear()
        nowMs = 0L
    }

    /** 설정을 바꿔 보는 테스트가 있어 수집 시작을 따로 둔다. */
    private fun start(config: ImuConfig = ImuConfig(batchSec = 1, trimEverySeq = 2, queueMinutes = 10)) {
        configSource.apply(config)
        repository =
            ImuRepositoryImpl(
                imuLocalDataSource = local,
                clockLocalDataSource = FakeClockLocalDataSource(),
                deviceInfoLocalDataSource = FakeDeviceInfoLocalDataSource(),
                imuRemoteDataSource = remote,
                imuConfigLocalDataSource = configSource,
                onBodyStateHolder = onBodyStateHolder,
                sendGate = SendGate { nowMs },
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
            // given
            start()

            // when
            emitSamplesUpTo(seconds = 1)

            stop()

            // then
            collected.size shouldBe 1
            // 끝낼 때 열려 있던 배치(마지막 샘플)도 이어서 보낸다
            remote.sentBatches.map { it.seq } shouldBe listOf(0L, 1L)
            remote.sentBatches.first() shouldBe collected.single()
        }

    @Test
    @DisplayName("전송 주기가 차기 전에는 배치를 모아 두고, 차면 모아 둔 배치를 한 번에 보낸다")
    fun holdsBatchesUntilTheGateOpens() =
        testScope.runTest {
            // given
            start()

            // when — 주기 전
            emitSamplesUpTo(seconds = 2)

            // then
            collected.map { it.seq } shouldBe listOf(0L, 1L)
            remote.sentBatches shouldBe emptyList()

            // when — 주기가 찬 뒤 다음 배치가 닫힌다
            nowMs += 5_000
            local.samples.emit(ImuSample(3 * ONE_SECOND_NS, 0f, 0f, 9.80665f))
            scheduler.runCurrent()

            // then — 수집을 끝내지 않아도 보낸다
            remote.sentBatches shouldBe collected
            remote.sentBatches.map { it.seq } shouldBe listOf(0L, 1L, 2L)
        }

    @Test
    @DisplayName("수집이 끝날 때 센서 FIFO 에 남아 있던 샘플도 배치로 묶어 보낸다")
    fun drainsTheSensorFifoOnStop() =
        testScope.runTest {
            // given — seq 0·1 이 닫히고 2초 샘플이 열린 배치에 있다. FIFO 에는 3·4초 샘플이 남아 있다
            start()
            emitSamplesUpTo(seconds = 2)
            local.drainedOnCancel = listOf(3L, 4L).map { ImuSample(it * ONE_SECOND_NS, 0f, 0f, 9.80665f) }

            // when
            stop()

            // then — 열린 배치와 FIFO 샘플이 이어서 seq 2·3·4 로 나간다
            remote.sentBatches.map { it.seq } shouldBe listOf(0L, 1L, 2L, 3L, 4L)
            remote.sentBatches.map { it.acc.t0ElapsedNs / ONE_SECOND_NS } shouldBe listOf(0L, 1L, 2L, 3L, 4L)
        }

    @Test
    @DisplayName("trimEverySeq 배수의 seq 마다 큐 정리를 호출한다")
    fun trimsTheQueueEveryConfiguredSeq() =
        testScope.runTest {
            // given
            start()

            // when — seq 0..3 네 배치
            emitSamplesUpTo(seconds = 4)

            stop()

            // then — seq 0, 2 에서만 정리한다
            collected.map { it.seq } shouldBe listOf(0L, 1L, 2L, 3L)
            // seq 4 는 끝낼 때 보낸 열린 배치다
            remote.trimmedSeqs shouldBe listOf(0L, 2L, 4L)
            remote.trimmedMaxItems shouldBe listOf(600, 600, 600)
        }

    @Test
    @DisplayName("큐 정리로 배치를 버리면 버린 구간을 기록한다")
    fun recordsTheDroppedRange() =
        testScope.runTest {
            // given
            remote.dropOnTrim = listOf(3L, 4L, 5L)
            start()

            // when
            emitSamplesUpTo(seconds = 1)

            stop()

            // then
            remote.droppedRanges shouldBe listOf(Dropped(collected.first().sessionId, 3L, 5L, "queue_overflow"))
        }

    @Test
    @DisplayName("전송이 실패해도 수집을 멈추지 않고 다음 배치를 보낸다")
    fun aFailedSendDoesNotStopTheStream() =
        testScope.runTest {
            // given
            remote.failSend = true
            start()

            // when — 게이트가 열려 seq 0·1 을 보내다 실패한다
            emitSampleAt(seconds = 0)
            emitSampleAt(seconds = 1)
            nowMs += 5_000
            emitSampleAt(seconds = 2)

            // then — 대기열에 못 넣은 배치는 하나씩 enqueue_failed 로 기록한다
            val sessionId = collected.first().sessionId
            remote.droppedRanges shouldBe (0L..1L).map { Dropped(sessionId, it, it, "enqueue_failed") }

            // when — 연결이 돌아온 뒤 다음 배치가 닫히고 게이트가 열린다
            remote.failSend = false
            nowMs += 5_000
            emitSampleAt(seconds = 3)

            // then — 같은 세션에서 수집이 이어져 seq 2 를 보낸다
            collected.map { it.seq } shouldBe listOf(0L, 1L, 2L)
            remote.sentBatches.map { it.seq to it.sessionId } shouldBe listOf(2L to sessionId)
        }

    @Test
    @DisplayName("벗은 상태면 on_body 는 false, wear_state 는 ACTUAL_NOT_WORN 이다")
    fun offBodyIsSentAsActualNotWorn() =
        testScope.runTest {
            // given
            start()
            onBodyStateHolder.update(false)

            // when
            emitSamplesUpTo(seconds = 1)

            // then
            collected.last().onBody shouldBe false
            collected.last().wearState shouldBe "ACTUAL_NOT_WORN"
        }

    @Test
    @DisplayName("착용 상태를 관측하지 못하면 on_body 는 true, wear_state 는 UNKNOWN 이다")
    fun unobservedOnBodyIsSentAsTrueWithUnknownWearState() =
        testScope.runTest {
            // given — 홀더가 null 인 상태
            start()

            // when
            emitSamplesUpTo(seconds = 1)

            // then
            collected.last().onBody shouldBe true
            collected.last().wearState shouldBe "UNKNOWN"
        }

    @Test
    @DisplayName("차고 있어도 최근 심박 정확도가 LOW 면 wear_state 는 WORN_INVALID 이다")
    fun lowHeartRateAccuracyIsWornInvalid() =
        testScope.runTest {
            // given
            start()
            onBodyStateHolder.update(true)
            onBodyStateHolder.updateHeartRateAccuracy("LOW")

            // when
            emitSamplesUpTo(seconds = 1)

            // then
            collected.last().wearState shouldBe "WORN_INVALID"
        }

    @Test
    @DisplayName("수집 중 설정이 바뀌면 모아 둔 배치를 보내고 새 설정으로 다시 수집한다")
    fun aConfigChangeRestartsCollection() =
        testScope.runTest {
            // given
            start()
            emitSamplesUpTo(seconds = 2)
            val before = collected.toList()

            // when
            configSource.apply(configSource.config().value.copy(collectionMode = "research"))
            scheduler.runCurrent()
            emitSamplesUpTo(seconds = 1)

            // then — 끊기기 전 배치와 열려 있던 배치(2초 샘플 하나)는 버려지지 않고, 새 세션은 연구 모드다
            remote.sentBatches.take(before.size) shouldBe before
            val partial = remote.sentBatches[before.size]
            partial.seq shouldBe before.size.toLong()
            partial.acc.t0ElapsedNs shouldBe 2 * ONE_SECOND_NS
            partial.acc.n shouldBe 1
            val after = collected.drop(before.size)
            after.isNotEmpty() shouldBe true
            after.forEach {
                it.collectionMode shouldBe "research"
                it.sessionId shouldNotBe before.first().sessionId
            }
        }

    /** 수집을 끝내 모아 둔 배치를 내보낸다. 전송 게이트는 실제 경과 시간으로 열려 단위 테스트에서는 열리지 않는다. */
    private fun stop() {
        collector.cancel()
        scheduler.runCurrent()
    }

    private suspend fun emitSampleAt(seconds: Int) {
        local.samples.emit(ImuSample(seconds * ONE_SECOND_NS, 0f, 0f, 9.80665f))
        scheduler.runCurrent()
    }

    /** [seconds] 개의 배치가 닫히도록 1초 간격 샘플을 흘린다. */
    private suspend fun emitSamplesUpTo(seconds: Int) {
        repeat(seconds + 1) { index ->
            local.samples.emit(
                ImuSample(index * ONE_SECOND_NS, 0f, 0f, 9.80665f),
            )
            scheduler.runCurrent()
        }
    }

    private class FakeImuConfigLocalDataSource : ImuConfigLocalDataSource {
        private val state = MutableStateFlow(ImuConfig())

        override fun config(): StateFlow<ImuConfig> = state

        override fun apply(config: ImuConfig) {
            state.value = config
        }
    }

    private class FakeImuLocalDataSource : ImuLocalDataSource {
        val samples = MutableSharedFlow<ImuSample>()

        /** 취소될 때 센서 FIFO 에서 비워 넘길 샘플. */
        var drainedOnCancel: List<ImuSample> = emptyList()

        override fun samples(
            config: ImuConfig,
            onDrained: (List<ImuSample>) -> Unit,
        ): Flow<ImuSample> = samples.onCompletion { onDrained(drainedOnCancel) }
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
        val droppedRanges = mutableListOf<Dropped>()
        var dropOnTrim: List<Long> = emptyList()
        var failSend = false
        var lastSentSeq = -1L

        override suspend fun sendBatch(batch: ImuBatch): Boolean {
            lastSentSeq = batch.seq
            if (failSend) return false
            sentBatches += batch
            return true
        }

        override suspend fun trimQueue(
            sessionId: String,
            maxItems: Int,
        ): List<Long> {
            trimmedSeqs += lastSentSeq
            trimmedMaxItems += maxItems
            return dropOnTrim
        }

        override suspend fun recordDrop(
            sessionId: String,
            fromSeq: Long,
            toSeq: Long,
            reason: String,
        ) {
            droppedRanges += Dropped(sessionId, fromSeq, toSeq, reason)
        }
    }

    private data class Dropped(
        val sessionId: String,
        val fromSeq: Long,
        val toSeq: Long,
        val reason: String,
    )

    private companion object {
        const val ONE_SECOND_NS = 1_000_000_000L
    }
}
