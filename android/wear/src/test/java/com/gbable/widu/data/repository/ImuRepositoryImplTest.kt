package com.gbable.widu.data.repository

import com.gbable.widu.data.model.AxisSeries
import com.gbable.widu.data.model.ClockAnchor
import com.gbable.widu.data.model.ImuBatch
import com.gbable.widu.data.model.ImuConfig
import com.gbable.widu.data.model.ImuSample
import com.gbable.widu.data.model.MissingReason
import com.gbable.widu.data.source.ClockLocalDataSource
import com.gbable.widu.data.source.DeviceInfoLocalDataSource
import com.gbable.widu.data.source.ImuLocalDataSource
import com.gbable.widu.data.source.ImuRemoteDataSource
import io.kotest.matchers.doubles.plusOrMinus
import io.kotest.matchers.nulls.shouldNotBeNull
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
    }

    /** 설정을 바꿔 보는 테스트가 있어 수집 시작을 따로 둔다. */
    private fun start(config: ImuConfig = ImuConfig(batchSec = 1, trimEverySeq = 2, queueMinutes = 10)) {
        repository =
            ImuRepositoryImpl(
                imuLocalDataSource = local,
                clockLocalDataSource = FakeClockLocalDataSource(),
                deviceInfoLocalDataSource = FakeDeviceInfoLocalDataSource(),
                imuRemoteDataSource = remote,
                config = config,
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

            // then
            collected.size shouldBe 1
            remote.sentBatches shouldBe collected
        }

    @Test
    @DisplayName("trimEverySeq 배수의 seq 마다 큐 정리를 호출한다")
    fun trimsTheQueueEveryConfiguredSeq() =
        testScope.runTest {
            // given
            start()

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
            start()

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
            start()

            // when
            emitSamplesUpTo(seconds = 3)

            // then
            collected.map { it.seq } shouldBe listOf(0L, 1L, 2L)
            remote.sentBatches shouldBe emptyList()
        }

    @Test
    @DisplayName("제품 모드 평시 배치에는 자이로를 싣지 않고 생략 사유를 남긴다")
    fun productModeOmitsGyroWhenNothingHappens() =
        testScope.runTest {
            // given
            start(productConfig())

            // when
            emitPairsUpTo(untilNs = 3 * ONE_SECOND_NS)

            // then — 0 으로 채우지 않고 null 로 둔다 (A 1.2.6)
            collected.map { it.gyro } shouldBe collected.map { null }
            collected.map { it.missingReason } shouldBe collected.map { MissingReason.OMITTED_BY_MODE }
        }

    @Test
    @DisplayName("충격이 나면 그 배치를 즉시 보내고 직전 2초 자이로를 보강 배치로 잇는다")
    fun anImpactIsSentAtOnceWithTheTwoSecondsBefore() =
        testScope.runTest {
            // given
            start(productConfig())

            // when — 3초 평시 → 3.4초에 2.5 g → 11초 평시
            emitPairsUpTo(untilNs = 16 * ONE_SECOND_NS, spikeAtNs = SPIKE_NS, spikeG = 2.5f)

            // then — 충격 배치에 표시가 붙고 urgent 로 나간다
            val impactIndex = collected.indexOfFirst { it.trigger != null }
            val impact = collected[impactIndex]
            val trigger = impact.trigger.shouldNotBeNull()
            trigger.kind shouldBe "impact"
            trigger.smvG.toDouble() shouldBe (2.5 plusOrMinus 1e-3)
            trigger.eventElapsedNs shouldBe SPIKE_NS
            remote.wasUrgent(impact) shouldBe true

            // and — 바로 다음이 보강 배치다
            val backfill = collected[impactIndex + 1]
            backfill.gyroBackfill shouldBe true
            backfill.backfillFor shouldBe impact.batchId
            backfill.acc shouldBe null
            backfill.trigger shouldBe null
            remote.wasUrgent(backfill) shouldBe true
            val backfilled = backfill.gyro.shouldNotBeNull().timestamps()
            backfilled.isNotEmpty() shouldBe true
            backfilled.all { it >= SPIKE_NS - 2 * ONE_SECOND_NS && it < SPIKE_NS } shouldBe true

            // and — 이후 10초는 자이로가 이어지고 그 뒤로는 다시 끊긴다
            collected[impactIndex + 2].gyro.shouldNotBeNull()
            collected.last().gyro shouldBe null
            collected.last().missingReason shouldBe MissingReason.OMITTED_BY_MODE
        }

    @Test
    @DisplayName("연구 모드는 충격이 없어도 모든 배치에 자이로를 싣는다")
    fun researchModeAlwaysCarriesGyro() =
        testScope.runTest {
            // given
            start(productConfig().copy(collectionMode = "research"))

            // when
            emitPairsUpTo(untilNs = 3 * ONE_SECOND_NS)

            // then
            collected.forEach { it.gyro.shouldNotBeNull() }
            collected.map { it.missingReason } shouldBe collected.map { null }
        }

    @Test
    @DisplayName("자이로 센서가 없으면 생략이 아니라 미지원으로 적는다")
    fun missingSensorIsNotTheSameAsOmission() =
        testScope.runTest {
            // given
            local.hasGyroscope = false
            start(productConfig().copy(collectionMode = "research"))

            // when
            emitPairsUpTo(untilNs = 3 * ONE_SECOND_NS)

            // then
            collected.map { it.gyro } shouldBe collected.map { null }
            collected.map { it.missingReason } shouldBe collected.map { MissingReason.SENSOR_UNSUPPORTED }
        }

    @Test
    @DisplayName("충격 배치와 보강 배치도 seq 를 소비해 번호가 끊기지 않는다")
    fun seqStaysContiguousAcrossTriggerAndBackfill() =
        testScope.runTest {
            // given
            start(productConfig())

            // when
            emitPairsUpTo(untilNs = 16 * ONE_SECOND_NS, spikeAtNs = SPIKE_NS, spikeG = 2.5f)

            // then
            collected.map { it.seq } shouldBe collected.indices.map { it.toLong() }
            collected.any { it.gyroBackfill } shouldBe true
        }

    @Test
    @DisplayName("문턱을 넘는 샘플이 연속으로 와도 충격 배치는 하나만 만들고 창만 연장한다")
    fun aSustainedSpikeProducesASingleTriggerBatch() =
        testScope.runTest {
            // given
            start(productConfig())

            // when — 3.4초부터 5 샘플(1초) 연속 2.5 g
            var ts = 0L
            while (ts <= 16 * ONE_SECOND_NS) {
                val spiking = ts >= SPIKE_NS && ts < SPIKE_NS + ONE_SECOND_NS
                val z = if (spiking) 2.5f * STANDARD_GRAVITY else STANDARD_GRAVITY
                local.samples.emit(ImuSample(ImuSample.Type.ACC, ts, 0f, 0f, z))
                local.samples.emit(ImuSample(ImuSample.Type.GYRO, ts, 0.1f, 0.2f, 0.3f))
                scheduler.runCurrent()
                ts += STEP_NS
            }

            // then — trigger 배치 1개, 보강 배치 1개
            collected.count { it.trigger != null } shouldBe 1
            collected.count { it.gyroBackfill } shouldBe 1
            // and — 창은 마지막 문턱 초과 샘플 기준으로 연장된다 (3.4 + 0.8 + 10 = 14.2초까지 자이로)
            val lastSpikeNs = SPIKE_NS + 4 * STEP_NS
            collected
                .filter { it.acc != null && it.acc!!.t0ElapsedNs in (SPIKE_NS + 1)..lastSpikeNs + 10 * ONE_SECOND_NS - ONE_SECOND_NS }
                .forEach { it.gyro.shouldNotBeNull() }
            collected.last().gyro shouldBe null
        }

    private fun productConfig() = ImuConfig(batchSec = 1, accHz = 50, trimEverySeq = 1_000, queueMinutes = 10)

    /** [STEP_NS] 간격으로 가속도·자이로 샘플을 함께 흘린다. */
    private suspend fun emitPairsUpTo(
        untilNs: Long,
        spikeAtNs: Long = -1L,
        spikeG: Float = 1f,
    ) {
        var ts = 0L
        while (ts <= untilNs) {
            val z = if (ts == spikeAtNs) spikeG * STANDARD_GRAVITY else STANDARD_GRAVITY
            local.samples.emit(ImuSample(ImuSample.Type.ACC, ts, 0f, 0f, z))
            local.samples.emit(ImuSample(ImuSample.Type.GYRO, ts, 0.1f, 0.2f, 0.3f))
            scheduler.runCurrent()
            ts += STEP_NS
        }
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
        var hasGyroscope = true

        override fun samples(): Flow<ImuSample> = samples

        override fun hasGyroscope(): Boolean = hasGyroscope
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

        val urgentFlags = mutableListOf<Boolean>()

        override suspend fun sendBatch(
            batch: ImuBatch,
            urgent: Boolean,
        ) {
            if (failSend) throw IllegalStateException("Disconnected")
            sentBatches += batch
            urgentFlags += urgent
        }

        fun wasUrgent(batch: ImuBatch): Boolean = urgentFlags[sentBatches.indexOf(batch)]

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
        const val STEP_NS = 200_000_000L
        const val SPIKE_NS = 3_400_000_000L
        const val STANDARD_GRAVITY = 9.80665f
    }
}

/** dt_ns 로 표현된 시각을 다시 펼친다. */
private fun AxisSeries.timestamps(): List<Long> =
    dtNs.fold(mutableListOf(t0ElapsedNs)) { acc, dt -> acc.apply { add(last() + dt) } }
