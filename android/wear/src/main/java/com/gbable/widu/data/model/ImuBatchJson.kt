package com.gbable.widu.data.model

import org.json.JSONArray
import org.json.JSONObject

/** [ImuBatch.toMap] 결과를 JSON 으로 옮기는 얇은 변환기. null 은 JSONObject.NULL 로 간다. */
object ImuBatchJson {
    fun toJson(batch: ImuBatch): JSONObject = toJsonValue(batch.toMap()) as JSONObject

    private fun toJsonValue(value: Any?): Any =
        when (value) {
            null -> JSONObject.NULL
            is Map<*, *> -> JSONObject().apply { value.forEach { (k, v) -> put(k.toString(), toJsonValue(v)) } }
            is List<*> -> JSONArray().apply { value.forEach { put(toJsonValue(it)) } }
            else -> value
        }
}

fun ImuBatch.toJson(): JSONObject = ImuBatchJson.toJson(this)
