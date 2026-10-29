package com.widucorp.widu.medication_alarm

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.CopyOnWriteArraySet

class MedicationAlarmPlugin : FlutterPlugin, MethodChannel.MethodCallHandler,
    ActivityAware, EventChannel.StreamHandler, PluginRegistry.NewIntentListener {
    private lateinit var context: android.content.Context
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var binding: ActivityPluginBinding? = null
    private var sink: EventChannel.EventSink? = null
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.widucorp.widu/medication_alarm")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(binding.binaryMessenger, "com.widucorp.widu/medication_alarm/events")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        onCancel(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            val scheduler = AlarmScheduler(context)
            val value: Any? = synchronized(AlarmStore.lock) {
                when (call.method) {
                    "capabilities" -> scheduler.capabilities()
                    "requestPermissions" -> {
                        val activity = requireNotNull(binding?.activity) { "FOREGROUND_REQUIRED" }
                        val caps = scheduler.capabilities()
                        if (Build.VERSION.SDK_INT >= 33 && !caps.getBoolean("notifications")) {
                            activity.requestPermissions(
                                arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                                4819
                            )
                        } else if (!caps.getBoolean("authorized")) openSettings(activity, "exact")
                        scheduler.capabilities()
                    }

                    "openSettings" -> {
                        openSettings(
                            requireNotNull(binding?.activity),
                            call.argument<String>("kind") ?: "app"
                        ); null
                    }

                    "activate" -> scheduler.activate(requireNotNull(call.argument<String>("memberId")))
                    "state" -> AlarmStore.read(context).also {
                        it.put("capabilities", scheduler.capabilities())
                        AlarmStore.write(context, it)
                    }

                    "activeGroup" -> AlarmStore.read(context).optJSONObject("activeGroup")
                        ?: JSONObject()

                    "applySchedule" -> scheduler.apply(
                        requireNotNull(call.argument<String>("sessionId")),
                        JSONObject(call.argument<Map<*, *>>("schedule")!!)
                    )

                    "complete" -> scheduler.complete(
                        requireNotNull(call.argument<String>("sessionId")),
                        call.argument<List<String>>("occurrenceIds")!!.toSet()
                    )

                    "stop" -> {
                        stop(context, requireNotNull(call.argument<String>("groupId"))); null
                    }

                    "clearSession" -> {
                        scheduler.clear(); null
                    }

                    "pendingLaunch" -> AlarmStore.objects(
                        AlarmStore.array(
                            AlarmStore.read(context),
                            "launches"
                        )
                    ).firstOrNull() ?: JSONObject()

                    "acknowledgeLaunch" -> {
                        val state = AlarmStore.read(context)
                        state.put(
                            "launches", JSONArray(
                                AlarmStore.objects(AlarmStore.array(state, "launches"))
                                    .filter { it.getString("eventId") != call.argument<String>("eventId") })
                        )
                        AlarmStore.write(context, state)
                        null
                    }

                    else -> {
                        result.notImplemented(); return
                    }
                }
            }
            result.success(if (value is JSONObject) AlarmStore.map(value) else value)
        } catch (e: Exception) {
            result.error("MEDICATION_ALARM", e.message, null)
        }
    }

    private fun openSettings(activity: Activity, kind: String) {
        val action = when {
            kind == "exact" && Build.VERSION.SDK_INT >= 31 -> Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM
            kind == "fullScreen" && Build.VERSION.SDK_INT >= 34 -> Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT
            else -> Settings.ACTION_APPLICATION_DETAILS_SETTINGS
        }
        activity.startActivity(Intent(action, Uri.parse("package:${context.packageName}")))
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addOnNewIntentListener(this)
        emit()
    }

    override fun onDetachedFromActivity() {
        binding?.removeOnNewIntentListener(this)
        binding = null
    }

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)

    override fun onNewIntent(intent: Intent): Boolean {
        emit(); return false
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        sink = events; sinks.add(events)
    }

    override fun onCancel(arguments: Any?) {
        sink?.let { sinks.remove(it) }; sink = null
    }

    companion object {
        private val sinks = CopyOnWriteArraySet<EventChannel.EventSink>()
        fun emit() {
            Handler(Looper.getMainLooper()).post { sinks.forEach { it.success(null) } }
        }

        internal fun stop(context: android.content.Context, groupId: String) =
            synchronized(AlarmStore.lock) {
                val state = AlarmStore.read(context)
                if (state.optJSONObject("activeGroup")?.optString("groupId") == groupId) {
                    state.remove("activeGroup")
                    AlarmStore.write(context, state)
                    context.stopService(Intent(context, AlarmPlaybackService::class.java))
                    emit()
                }
            }
    }
}
