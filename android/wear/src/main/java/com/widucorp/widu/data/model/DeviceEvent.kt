package com.widucorp.widu.data.model

import org.json.JSONObject

/** 서버 `POST /api/v1/device/events` 항목 하나. 폰이 그대로 묶어 올린다. */
data class DeviceEvent(
    val eventId: String,
    val deviceId: String,
    val kind: String,
    val occurredAtMs: Long,
    /** 키는 서버가 검사하지 않는 앱과의 약속이다. 값이 null 인 키는 싣지 않는다. */
    val attributes: Map<String, Any> = emptyMap(),
) {
    fun toJson(): JSONObject =
        ImuBatchJson.toJson(
            mapOf(
                "event_id" to eventId,
                "device_id" to deviceId,
                "source" to SOURCE,
                "kind" to kind,
                "occurred_at_ms" to occurredAtMs,
                "attributes" to attributes,
            ),
        )

    private companion object {
        const val SOURCE = "watch"
    }
}

object DeviceEventKind {
    const val CHARGING_STARTED = "CHARGING_STARTED"
    const val CHARGING_STOPPED = "CHARGING_STOPPED"
    const val WEAR_CHANGED = "WEAR_CHANGED"
    const val PHONE_DISCONNECTED = "PHONE_DISCONNECTED"
    const val PHONE_RECONNECTED = "PHONE_RECONNECTED"
    const val POWER_SAVE_CHANGED = "POWER_SAVE_CHANGED"
    const val BRIGHTNESS_CHANGED = "BRIGHTNESS_CHANGED"
    const val SCREEN_ON = "SCREEN_ON"
    const val SCREEN_OFF = "SCREEN_OFF"
    const val SENT_TO_PHONE = "SENT_TO_PHONE"
}
