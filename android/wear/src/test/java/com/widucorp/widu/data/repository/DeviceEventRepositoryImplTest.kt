package com.widucorp.widu.data.repository

import com.widucorp.widu.data.model.DeviceEvent
import com.widucorp.widu.data.model.DeviceEventKind
import com.widucorp.widu.data.model.ImuConfig
import com.widucorp.widu.data.source.DeviceEventRemoteDataSource
import com.widucorp.widu.data.source.DeviceInfoLocalDataSource
import com.widucorp.widu.data.source.DeviceStateLocalDataSource
import com.widucorp.widu.data.source.ImuConfigLocalDataSource
import com.widucorp.widu.data.util.OnBodyStateHolder
import com.widucorp.widu.data.util.SendStats
import io.kotest.matchers.collections.shouldBeEmpty
import io.kotest.matchers.shouldBe
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.runCurrent
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import java.io.BufferedWriter

@OptIn(ExperimentalCoroutinesApi::class)
class DeviceEventRepositoryImplTest {
    private lateinit var state: FakeDeviceStateLocalDataSource
    private lateinit var configSource: FakeImuConfigLocalDataSource
    private lateinit var remote: FakeDeviceEventRemoteDataSource
    private lateinit var onBodyStateHolder: OnBodyStateHolder
    private val collected = mutableListOf<DeviceEvent>()

    @BeforeEach
    fun setUp() {
        state = FakeDeviceStateLocalDataSource()
        configSource = FakeImuConfigLocalDataSource()
        remote = FakeDeviceEventRemoteDataSource()
        onBodyStateHolder = OnBodyStateHolder()
        collected.clear()
        SendStats.drain()
    }

    private fun TestScope.start(collectionMode: String) {
        configSource.apply(ImuConfig(collectionMode = collectionMode))
        val repository =
            DeviceEventRepositoryImpl(
                deviceStateLocalDataSource = state,
                deviceInfoLocalDataSource = FakeDeviceInfoLocalDataSource(),
                imuConfigLocalDataSource = configSource,
                onBodyStateHolder = onBodyStateHolder,
                deviceEventRemoteDataSource = remote,
            )
        backgroundScope.launch { repository.events().collect { collected += it } }
        runCurrent()
    }

    @Test
    @DisplayName("제품 모드에서는 상태가 바뀌어도 이벤트를 만들지 않는다")
    fun productModeEmitsNothing() =
        runTest {
            // given
            start("product")

            // when
            state.charging.value = true
            state.screenOn.value = false
            runCurrent()

            // then
            collected.shouldBeEmpty()
            remote.sent.shouldBeEmpty()
        }

    @Test
    @DisplayName("연구 모드는 시작 값은 남기지 않고 바뀐 상태만 이벤트로 보낸다")
    fun researchModeSendsOnlyChanges() =
        runTest {
            // given
            start("research")

            // when
            state.charging.value = true
            state.screenOn.value = false
            state.brightness.value = 40
            state.phoneConnected.value = false
            runCurrent()

            // then
            collected.map { it.kind } shouldBe
                listOf(
                    DeviceEventKind.CHARGING_STARTED,
                    DeviceEventKind.SCREEN_OFF,
                    DeviceEventKind.BRIGHTNESS_CHANGED,
                    DeviceEventKind.PHONE_DISCONNECTED,
                )
            collected[0].attributes shouldBe mapOf("battery_pct" to 77)
            collected[2].attributes shouldBe mapOf("level" to 40)
            remote.sent shouldBe collected
        }

    @Test
    @DisplayName("착용 판정값이나 센서 원래 값 중 하나만 바뀌어도 둘 다 실어 남긴다")
    fun wearChangedCarriesBothValues() =
        runTest {
            // given
            start("research")
            onBodyStateHolder.update(true)
            runCurrent()

            // when
            state.offBodyRaw.value = 0
            runCurrent()
            onBodyStateHolder.update(false)
            runCurrent()

            // then
            collected.map { it.attributes } shouldBe
                listOf(
                    mapOf("on_body" to true, "sensor_raw" to 0),
                    mapOf("on_body" to false, "sensor_raw" to 0),
                )
        }

    @Test
    @DisplayName("1분마다 그동안 넘긴 배치 수와 바이트를 묶어 남기고, 넘긴 것이 없으면 남기지 않는다")
    fun sentToPhoneIsAggregatedPerMinute() =
        runTest {
            // given
            start("research")
            SendStats.record(100)
            SendStats.record(50)

            // when
            advanceTimeBy(60_001)
            advanceTimeBy(60_000)

            // then
            collected.map { it.attributes } shouldBe listOf(mapOf("batch_count" to 2, "bytes" to 150L))
        }

    @Test
    @DisplayName("연구 모드에서 제품 모드로 바꾸면 수집을 멈춘다")
    fun stopsWhenSwitchedToProduct() =
        runTest {
            // given
            start("research")

            // when
            configSource.apply(ImuConfig(collectionMode = "product"))
            runCurrent()
            state.charging.value = true
            runCurrent()

            // then
            collected.shouldBeEmpty()
        }

    private class FakeDeviceStateLocalDataSource : DeviceStateLocalDataSource {
        val charging = MutableStateFlow(false)
        val powerSave = MutableStateFlow(false)
        val screenOn = MutableStateFlow(true)
        val brightness = MutableStateFlow(100)
        val offBodyRaw = MutableStateFlow<Int?>(1)
        val phoneConnected = MutableStateFlow(true)

        override fun charging(): Flow<Boolean> = charging

        override fun powerSave(): Flow<Boolean> = powerSave

        override fun screenOn(): Flow<Boolean> = screenOn

        override fun brightness(): Flow<Int> = brightness

        override fun offBodyRaw(): Flow<Int?> = offBodyRaw

        override fun phoneConnected(): Flow<Boolean> = phoneConnected
    }

    private class FakeImuConfigLocalDataSource : ImuConfigLocalDataSource {
        private val state = MutableStateFlow(ImuConfig())

        override fun config(): StateFlow<ImuConfig> = state

        override fun apply(config: ImuConfig) {
            state.value = config
        }
    }

    private class FakeDeviceInfoLocalDataSource : DeviceInfoLocalDataSource {
        override fun deviceId(): String = "gw-test"

        override fun batteryPercent(): Int = 77

        override fun openRawLog(): BufferedWriter? = null
    }

    private class FakeDeviceEventRemoteDataSource : DeviceEventRemoteDataSource {
        val sent = mutableListOf<DeviceEvent>()

        override suspend fun send(event: DeviceEvent) {
            sent += event
        }
    }
}
