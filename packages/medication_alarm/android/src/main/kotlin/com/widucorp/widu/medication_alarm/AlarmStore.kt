package com.widucorp.widu.medication_alarm

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.util.UUID

internal object AlarmStore {
    // Receivers, the foreground engine and the FCM engine use this same lock.
    val lock = Any()
    fun read(context: Context): JSONObject {
        val prefs = context.createDeviceProtectedStorageContext()
            .getSharedPreferences("widyu_medication_alarm", Context.MODE_PRIVATE)
        val value = prefs.getString("state", null)
        return if (value != null) JSONObject(value) else JSONObject()
            .put("installationId", UUID.randomUUID().toString())
    }

    fun write(context: Context, state: JSONObject) {
        check(
            context.createDeviceProtectedStorageContext()
                .getSharedPreferences("widyu_medication_alarm", Context.MODE_PRIVATE)
                .edit().putString("state", state.toString()).commit()
        ) { "Alarm state write failed" }
    }

    fun array(json: JSONObject, key: String): JSONArray = json.optJSONArray(key) ?: JSONArray()
    fun objects(array: JSONArray): List<JSONObject> =
        (0 until array.length()).map { array.getJSONObject(it) }

    fun strings(array: JSONArray): Set<String> =
        (0 until array.length()).map { array.getString(it) }.toSet()

    fun map(json: JSONObject): Map<String, Any?> = json.keys().asSequence().associateWith {
        when (val value = json.get(it)) {
            JSONObject.NULL -> null
            is JSONObject -> map(value)
            is JSONArray -> list(value)
            else -> value
        }
    }

    private fun list(array: JSONArray): List<Any?> = (0 until array.length()).map {
        when (val value = array.get(it)) {
            JSONObject.NULL -> null
            is JSONObject -> map(value)
            is JSONArray -> list(value)
            else -> value
        }
    }

    fun requireSession(state: JSONObject, session: String) {
        check(session.isNotEmpty() && state.optString("sessionId") == session) { "STALE_SESSION" }
    }

    fun enqueueLaunch(context: Context, group: JSONObject) = synchronized(lock) {
        val state = read(context)
        if (group.optString("memberId") != state.optString("memberId")) return@synchronized
        val pending = array(state, "launches")
        if (objects(pending).none {
                it.getJSONObject("group").getString("groupId") == group.getString("groupId")
            }) {
            pending.put(
                JSONObject().put("eventId", UUID.randomUUID().toString())
                    .put("memberId", state.getString("memberId")).put("group", group)
            )
            state.put("launches", JSONArray(objects(pending).takeLast(8)))
            write(context, state)
        }
        MedicationAlarmPlugin.emit()
    }
}
