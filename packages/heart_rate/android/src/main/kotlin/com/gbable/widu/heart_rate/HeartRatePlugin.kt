package com.gbable.widu.heart_rate

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
import java.util.concurrent.CopyOnWriteArraySet

class HeartRatePlugin :
    FlutterPlugin,
    EventChannel.StreamHandler,
    MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private lateinit var nodeClient: NodeClient
    private lateinit var messageClient: MessageClient

    // eventSinks 는 메인 엔진과 백그라운드 서비스 엔진이 공유하지만
    // StreamHandler 는 엔진마다 별도 인스턴스이므로,
    // 자신이 등록한 sink 만 정확히 회수할 수 있도록 따로 들고 있는다.
    private var eventSink: EventChannel.EventSink? = null

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
        releaseEventSink()
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
        eventSink = events
        events?.let { eventSinks.add(it) }
    }

    // 다른 엔진이 등록한 sink 까지 지우면 그 엔진의 심박수 수신이 영구히 끊기므로
    // 반드시 자신의 sink 만 제거한다.
    override fun onCancel(arguments: Any?) {
        releaseEventSink()
    }

    private fun releaseEventSink() {
        eventSink?.let { eventSinks.remove(it) }
        eventSink = null
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
        private const val HEART_RATE_CHANNEL = "com.gbable.widu/heart_rate"
        private const val HEART_RATE_STATUS_CHANNEL = "com.gbable.widu/heart_rate_status"
        private const val HEART_RATE_KEY = "heartRate"
        private const val TIMESTAMP_KEY = "timestamp"
        private const val HEART_RATE_STATUS_KEY = "heartRateStatus"
        private const val HEART_RATE_STATUS_PATH = "/heart_rate_status"

        // Data Layer 콜백 스레드에서 등록·해제되고 메인 스레드에서 순회되므로
        // 동시 접근에 안전한 컬렉션을 사용한다.
        private val eventSinks = CopyOnWriteArraySet<EventChannel.EventSink>()

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
                        eventSinks.remove(sink)
                        Log.e("HeartRatePlugin", "Error sending heart rate to sink", e)
                    }
                }
            }
        }
    }
}
