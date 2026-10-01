package com.widyu.medication_alarm

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.os.Build
import androidx.core.app.NotificationManagerCompat
import org.json.JSONArray
import org.json.JSONObject
import java.time.LocalDate
import java.time.LocalTime
import java.time.ZoneId
import java.util.UUID

internal class AlarmScheduler(private val context: Context) {
    private val alarms = context.getSystemService(AlarmManager::class.java)
    private val notifications = context.getSystemService(NotificationManager::class.java)
    init {
        notifications.createNotificationChannel(NotificationChannel(CHANNEL, "약 복용 알람",
            NotificationManager.IMPORTANCE_HIGH).apply {
            description = "예약된 복용 시각에 울리는 알람"
            // The service owns audio/vibration; the channel must not double-play.
            setSound(null, AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ALARM).build())
            enableVibration(false)
            lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC
        })
    }
    fun capabilities(): JSONObject = JSONObject()
        .put("platform", "android").put("mode", "exactAlarm")
        .put("timeZone", ZoneId.systemDefault().id)
        .put("osVersion", Build.VERSION.RELEASE)
        .put("authorized", Build.VERSION.SDK_INT < 31 || alarms.canScheduleExactAlarms())
        .put("notifications", NotificationManagerCompat.from(context).areNotificationsEnabled() &&
            notifications.getNotificationChannel(CHANNEL)?.importance != NotificationManager.IMPORTANCE_NONE)
        .put("fullScreen", Build.VERSION.SDK_INT < 34 || notifications.canUseFullScreenIntent())

    fun activate(memberId: String): JSONObject = synchronized(AlarmStore.lock) {
        require(memberId.isNotBlank())
        var state = AlarmStore.read(context)
        if (state.optString("memberId") != memberId || !state.has("sessionId")) {
            clear()
            state = AlarmStore.read(context).put("memberId", memberId)
                .put("sessionId", UUID.randomUUID().toString()).put("revision", -1)
        }
        AlarmStore.write(context, state)
        if (state.has("plan")) reconcile(force = true)
        AlarmStore.read(context)
    }

    fun clear() = synchronized(AlarmStore.lock) {
        val state = AlarmStore.read(context)
        // Invalidate first so a delayed background response cannot resurrect it.
        AlarmStore.write(context, JSONObject().put("installationId", state.getString("installationId")))
        (AlarmStore.objects(AlarmStore.array(state, "scheduled")) +
            AlarmStore.objects(AlarmStore.array(state, "applying"))).forEach { cancel(it) }
        context.stopService(Intent(context, AlarmPlaybackService::class.java))
        MedicationAlarmPlugin.emit()
    }

    fun apply(sessionId: String, plan: JSONObject): JSONObject = synchronized(AlarmStore.lock) {
        val state = AlarmStore.read(context)
        AlarmStore.requireSession(state, sessionId)
        require(plan.getBoolean("complete") && plan.getString("memberId") == state.getString("memberId"))
        require(plan.getString("timeZone") == ZoneId.systemDefault().id) { "TIMEZONE_CHANGED" }
        check(plan.getLong("revision") >= state.optLong("revision", -1)) { "STALE_REVISION" }
        state.put("plan", plan).put("revision", plan.getLong("revision"))
        AlarmStore.write(context, state)
        reconcile()
    }

    fun complete(sessionId: String, ids: Set<String>): JSONObject = synchronized(AlarmStore.lock) {
        val state = AlarmStore.read(context)
        AlarmStore.requireSession(state, sessionId)
        state.put("completed", JSONArray((AlarmStore.strings(AlarmStore.array(state, "completed")) + ids).sorted().takeLast(4096)))
        AlarmStore.write(context, state)
        reconcile()
    }

    /** Reschedule from local daily rules, even without Flutter or connectivity. */
    fun reconcile(force: Boolean = false): JSONObject = synchronized(AlarmStore.lock) {
        val state = AlarmStore.read(context)
        val caps = capabilities()
        val plan = state.optJSONObject("plan")
        val previous = AlarmStore.objects(AlarmStore.array(state, "scheduled"))
        val journal = AlarmStore.objects(AlarmStore.array(state, "applying"))
        val canSchedule = caps.getBoolean("authorized") && caps.getBoolean("notifications")
        val desired = if (plan != null && state.has("sessionId") && canSchedule) nextGroups(state) else emptyList()
        val actual = mutableListOf<JSONObject>()
        val failures = JSONArray()
        journal.forEach { cancel(it) }
        state.put("applying", JSONArray(desired))
        AlarmStore.write(context, state)
        previous.filter { old -> desired.none { same(old, it) } || force }.forEach { cancel(it) }
        for (group in desired) {
            try {
                if (force || journal.isNotEmpty() || previous.none { same(it, group) }) {
                    // Persist intent identity before touching the OS (crash recovery).
                    val pending = operation(group)
                    alarms.setAlarmClock(AlarmManager.AlarmClockInfo(group.getLong("scheduledAt"), show(group)), pending)
                }
                actual.add(group)
            } catch (e: Exception) {
                failures.put(JSONObject().put("groupId", group.getString("groupId")).put("code", e.javaClass.simpleName))
            }
        }
        // Keep active payload in sync when a dose is completed or deleted.
        state.optJSONObject("activeGroup")?.let { active ->
            val excluded = exclusions(state)
            val rules = plan?.let { AlarmStore.objects(it.getJSONArray("schedules")) } ?: emptyList()
            val remaining = AlarmStore.objects(active.getJSONArray("occurrences")).filter { occurrence ->
                !excluded.contains(occurrence.getString("occurrenceId")) && rules.any { rule ->
                    rule.getBoolean("enabled") && rule.getLong("scheduleId") == occurrence.getLong("scheduleId") &&
                        LocalTime.parse(rule.getString("alarmTime")) == java.time.Instant.ofEpochMilli(occurrence.getLong("scheduledAt"))
                            .atZone(ZoneId.systemDefault()).toLocalTime().withSecond(0).withNano(0)
                }
            }
            if (remaining.isEmpty() || !canSchedule || System.currentTimeMillis() - active.getLong("scheduledAt") >= 5 * 60000) {
                state.remove("activeGroup")
                context.stopService(Intent(context, AlarmPlaybackService::class.java))
            } else active.put("occurrences", JSONArray(remaining))
        }
        val status = JSONObject().put("capabilities", caps)
            .put("desiredRevision", state.optLong("revision", -1))
            .put("appliedRevision", if (failures.length() == 0 && canSchedule) state.optLong("revision", -1) else JSONObject.NULL)
            .put("continuous", canSchedule && failures.length() == 0 && desired.isNotEmpty())
            .put("scheduledThrough", JSONObject.NULL).put("scheduledCount", actual.size)
            .put("failures", failures).put("timeZone", ZoneId.systemDefault().id)
            .put("status", if (!canSchedule) "permissionRequired" else if (failures.length() > 0) "partialFailure" else "scheduled")
            .put("reportedAt", System.currentTimeMillis())
        state.put("scheduled", JSONArray(actual)).put("status", status)
        state.remove("applying")
        AlarmStore.write(context, state)
        MedicationAlarmPlugin.emit()
        status
    }

    private fun exclusions(state: JSONObject): Set<String> =
        AlarmStore.strings(AlarmStore.array(state, "completed")) +
            (state.optJSONObject("plan")?.let { AlarmStore.strings(it.getJSONArray("excludedOccurrenceIds")) } ?: emptySet())

    private fun nextGroups(state: JSONObject): List<JSONObject> {
        val zone = ZoneId.systemDefault()
        val now = System.currentTimeMillis()
        val excluded = exclusions(state)
        val grouped = sortedMapOf<Long, MutableList<JSONObject>>()
        for (rule in AlarmStore.objects(state.getJSONObject("plan").getJSONArray("schedules"))) {
            if (!rule.getBoolean("enabled")) continue
            val time = LocalTime.parse(rule.getString("alarmTime"))
            for (offset in 0L..366L) {
                val date = LocalDate.now(zone).plusDays(offset)
                val at = date.atTime(time).atZone(zone).toInstant().toEpochMilli()
                val id = "${rule.getLong("scheduleId")}:$date"
                if (at <= now || excluded.contains(id)) continue
                val occurrence = JSONObject().put("occurrenceId", id).put("scheduleId", rule.getLong("scheduleId"))
                    .put("localDate", date.toString()).put("timeZone", zone.id).put("scheduledAt", at)
                    .put("doseCount", rule.getDouble("doseCount"))
                    .put("opensAt", maxOf(at - 30 * 60000, date.atStartOfDay(zone).toInstant().toEpochMilli()))
                    .put("closesAt", minOf(at + 30 * 60000, date.atTime(23, 59).atZone(zone).toInstant().toEpochMilli()))
                grouped.getOrPut(at) { mutableListOf() }.add(occurrence)
                break
            }
        }
        return grouped.map { (at, occurrences) -> JSONObject()
            .put("groupId", "${state.getString("memberId")}:$at").put("memberId", state.getString("memberId"))
            .put("scheduledAt", at).put("timeZone", zone.id)
            .put("occurrences", JSONArray(occurrences.sortedBy { it.getLong("scheduleId") })) }
    }

    fun fired(id: String): JSONObject? = synchronized(AlarmStore.lock) {
        val state = AlarmStore.read(context)
        val group = AlarmStore.objects(AlarmStore.array(state, "scheduled")).firstOrNull { it.getString("groupId") == id }
            ?: return@synchronized null
        val fired = AlarmStore.strings(AlarmStore.array(state, "fired"))
        if (fired.contains(id)) return@synchronized null
        val age = System.currentTimeMillis() - group.getLong("scheduledAt")
        if (age < 0) return@synchronized null
        state.put("fired", JSONArray((fired + id).toList().takeLast(1024)))
        if (age < 5 * 60000 && capabilities().getBoolean("notifications")) state.put("activeGroup", group)
        AlarmStore.write(context, state)
        reconcile()
        if (age < 5 * 60000) AlarmStore.read(context).optJSONObject("activeGroup") else null
    }

    private fun same(a: JSONObject, b: JSONObject) = a.toString() == b.toString()
    private fun operation(group: JSONObject) = PendingIntent.getBroadcast(context, 0,
        Intent(context, AlarmReceiver::class.java).setAction("com.widyu.medication.FIRE")
            .setData(android.net.Uri.parse("widyu-alarm://fire/${group.getString("groupId")}"))
            .putExtra("groupId", group.getString("groupId")),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    fun show(group: JSONObject, verify: Boolean = false): PendingIntent = PendingIntent.getActivity(context, if (verify) 1 else 0,
        Intent(context, AlarmActivity::class.java)
            .setData(android.net.Uri.parse("widyu-alarm://show/${group.getString("groupId")}"))
            .putExtra("groupId", group.getString("groupId")).putExtra("verify", verify)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    private fun cancel(group: JSONObject) { alarms.cancel(operation(group)) }
    companion object { const val CHANNEL = "widyu_medication_alarm_v1" }
}
