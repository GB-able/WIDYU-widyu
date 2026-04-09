package com.example.widyu.heart_rate

import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.NodeClient
import com.google.android.gms.wearable.Wearable
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class HeartRatePlugin :
    FlutterPlugin,
    EventChannel.StreamHandler,
    MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private lateinit var nodeClient: NodeClient
    private lateinit var messageClient: MessageClient

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        nodeClient = Wearable.getNodeClient(binding.applicationContext)
        messageClient = Wearable.getMessageClient(binding.applicationContext)

        eventChannel =
            EventChannel(
                binding.binaryMessenger,
                HEART_RATE_CHANNEL,
            ).apply { setStreamHandler(this@HeartRatePlugin) }

        methodChannel =
            MethodChannel(
                binding.binaryMessenger,
                HEART_RATE_STATUS_CHANNEL,
            ).apply { setMethodCallHandler(this@HeartRatePlugin) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        eventChannel?.setStreamHandler(null)
        methodChannel?.setMethodCallHandler(null)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result,
    ) {
        when (call.method) {
            "fetchHeartRateStatus" -> {
                val status = call.argument<String>(HEART_RATE_STATUS_KEY) ?: ""
                sendHeartRateStatus(status)
                result.success(true)
            }

            else -> result.notImplemented()
        }
    }

    override fun onListen(
        arguments: Any?,
        events: EventChannel.EventSink?,
    ) {
        events?.let { eventSinks.add(it) }
    }

    override fun onCancel(arguments: Any?) {
        eventSinks.clear()
    }

    private fun sendHeartRateStatus(status: String) {
        nodeClient.connectedNodes.addOnSuccessListener { nodes ->
            if (nodes.isEmpty()) return@addOnSuccessListener
            nodes.forEach { node ->
                messageClient
                    .sendMessage(node.id, HEART_RATE_STATUS_PATH, status.toByteArray())
                    .addOnFailureListener { Log.i("Widyu", "Error in sendHeartRateStatus", it) }
            }
        }
    }

    companion object {
        private const val HEART_RATE_CHANNEL = "com.example.widyu/heart_rate"
        private const val HEART_RATE_STATUS_CHANNEL = "com.example.widyu/heart_rate_status"
        private const val HEART_RATE_KEY = "heartRate"
        private const val TIMESTAMP_KEY = "timestamp"
        private const val HEART_RATE_STATUS_KEY = "heartRateStatus"
        private const val HEART_RATE_STATUS_PATH = "/heart_rate_status"

        private val eventSinks = mutableSetOf<EventChannel.EventSink>()

        fun sendHeartRate(
            heartRate: Int,
            timestamp: Long,
        ) {
            Handler(Looper.getMainLooper()).post {
                val data =
                    mapOf(
                        HEART_RATE_KEY to heartRate,
                        TIMESTAMP_KEY to timestamp,
                    )
                eventSinks.forEach { sink ->
                    try {
                        sink.success(data)
                    } catch (e: Exception) {
                        Log.e("HeartRatePlugin", "Error sending heart rate to sink", e)
                    }
                }
            }
        }
    }
}
