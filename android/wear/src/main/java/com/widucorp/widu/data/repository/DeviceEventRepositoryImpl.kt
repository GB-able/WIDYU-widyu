package com.widucorp.widu.data.repository

import com.widucorp.widu.data.model.DeviceEvent
import com.widucorp.widu.data.model.DeviceEventKind
import com.widucorp.widu.data.source.DeviceEventRemoteDataSource
import com.widucorp.widu.data.source.DeviceInfoLocalDataSource
import com.widucorp.widu.data.source.DeviceStateLocalDataSource
import com.widucorp.widu.data.source.ImuConfigLocalDataSource
import com.widucorp.widu.data.util.OnBodyStateHolder
import com.widucorp.widu.data.util.SendStats
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.drop
import kotlinx.coroutines.flow.emptyFlow
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.merge
import kotlinx.coroutines.flow.onEach
import java.util.UUID
import java.util.concurrent.TimeUnit
import javax.inject.Inject

class DeviceEventRepositoryImpl @Inject constructor(
    private val deviceStateLocalDataSource: DeviceStateLocalDataSource,
    private val deviceInfoLocalDataSource: DeviceInfoLocalDataSource,
    private val imuConfigLocalDataSource: ImuConfigLocalDataSource,
    private val onBodyStateHolder: OnBodyStateHolder,
    private val deviceEventRemoteDataSource: DeviceEventRemoteDataSource,
) : DeviceEventRepository {
    /** 수집 모드만 본다. 다른 설정이 바뀌어도 감시를 다시 시작하지 않아야 시작 값이 이벤트로 새지 않는다. */
    @OptIn(ExperimentalCoroutinesApi::class)
    override fun events(): Flow<DeviceEvent> =
        imuConfigLocalDataSource
            .config()
            .map { it.collectionMode == RESEARCH_MODE }
            .distinctUntilChanged()
            .flatMapLatest { isResearch -> if (isResearch) collect() else emptyFlow() }

    private fun collect(): Flow<DeviceEvent> {
        val state = deviceStateLocalDataSource
        return merge(
            state.charging().changes().map { charging ->
                event(
                    if (charging) DeviceEventKind.CHARGING_STARTED else DeviceEventKind.CHARGING_STOPPED,
                    "battery_pct" to deviceInfoLocalDataSource.batteryPercent(),
                )
            },
            // 앱 판정값과 센서 원래 값이 어긋나는 순간을 보려는 기록이라, 둘 중 하나만 바뀌어도 남긴다.
            combine(onBodyStateHolder.state.filterNotNull(), state.offBodyRaw()) { onBody, raw -> onBody to raw }
                .changes()
                .map { (onBody, raw) -> event(DeviceEventKind.WEAR_CHANGED, "on_body" to onBody, "sensor_raw" to raw) },
            state.phoneConnected().changes().map { connected ->
                event(if (connected) DeviceEventKind.PHONE_RECONNECTED else DeviceEventKind.PHONE_DISCONNECTED)
            },
            state.powerSave().changes().map { event(DeviceEventKind.POWER_SAVE_CHANGED, "enabled" to it) },
            state.brightness().changes().map { event(DeviceEventKind.BRIGHTNESS_CHANGED, "level" to it) },
            state.screenOn().changes().map { on -> event(if (on) DeviceEventKind.SCREEN_ON else DeviceEventKind.SCREEN_OFF) },
            sentToPhone(),
        ).onEach { deviceEventRemoteDataSource.send(it) }
    }

    private fun sentToPhone(): Flow<DeviceEvent> =
        flow {
            // 연구 모드 전에 쌓인 값은 버린다.
            SendStats.drain()
            while (true) {
                delay(SENT_TO_PHONE_INTERVAL_MS)
                val (count, bytes) = SendStats.drain()
                if (count > 0) emit(event(DeviceEventKind.SENT_TO_PHONE, "batch_count" to count, "bytes" to bytes))
            }
        }

    /** 시작 시 현재 값은 변화가 아니므로 버린다. */
    private fun <T> Flow<T>.changes(): Flow<T> = distinctUntilChanged().drop(1)

    private fun event(
        kind: String,
        vararg attributes: Pair<String, Any?>,
    ) = DeviceEvent(
        eventId = UUID.randomUUID().toString(),
        deviceId = deviceInfoLocalDataSource.deviceId(),
        kind = kind,
        occurredAtMs = System.currentTimeMillis(),
        attributes = attributes.mapNotNull { (key, value) -> value?.let { key to it } }.toMap(),
    )

    private companion object {
        const val RESEARCH_MODE = "research"
        val SENT_TO_PHONE_INTERVAL_MS = TimeUnit.MINUTES.toMillis(1)
    }
}
