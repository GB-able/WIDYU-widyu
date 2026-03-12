package com.example.widyu

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.NodeClient
import com.google.android.gms.wearable.Wearable
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class HeartRateChannelManager(
    context: Context,
) : EventChannel.StreamHandler,
    MethodChannel.MethodCallHandler {
    private var eventSink: EventChannel.EventSink? = null
    private val nodeClient: NodeClient by lazy { Wearable.getNodeClient(context) }
    private val messageClient: MessageClient by lazy { Wearable.getMessageClient(context) }

    fun initialize(messenger: BinaryMessenger) {
        EventChannel(messenger, HEART_RATE_CHANNEL).setStreamHandler(this)
        MethodChannel(messenger, HEART_RATE_STATUS_CHANNEL).setMethodCallHandler(this)
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
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

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
            eventSink?.success(data)
        }
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
    }
}
