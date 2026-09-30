package com.gbable.widu.heart_rate

import android.content.Context
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.DataItem
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.NodeClient
import com.google.android.gms.wearable.Wearable
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.nio.charset.StandardCharsets
import java.util.concurrent.CopyOnWriteArraySet

class HeartRatePlugin :
    FlutterPlugin,
    EventChannel.StreamHandler,
    MethodChannel.MethodCallHandler {
    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var sensorBatchChannel: EventChannel? = null
    private lateinit var nodeClient: NodeClient
    private lateinit var messageClient: MessageClient
    private var applicationContext: Context? = null

    // eventSinks 는 메인 엔진과 백그라운드 서비스 엔진이 공유하지만
    // StreamHandler 는 엔진마다 별도 인스턴스이므로,
    // 자신이 등록한 sink 만 정확히 회수할 수 있도록 따로 들고 있는다.
    private var eventSink: EventChannel.EventSink? = null
    private var sensorBatchSink: EventChannel.EventSink? = null

    private val sensorBatchStreamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            val wasEmpty = sensorBatchSinks.isEmpty()
            sensorBatchSink = events
            events?.let { sensorBatchSinks.add(it) }
            // 엔진이 죽어 있던 동안 서비스가 남겨 둔 묶음을 첫 sink 등록 시 되살린다.
            if (wasEmpty && events != null) drainPendingImuItems()
        }

        override fun onCancel(arguments: Any?) {
            releaseSensorBatchSink()
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        nodeClient = Wearable.getNodeClient(binding.applicationContext)
        messageClient = Wearable.getMessageClient(binding.applicationContext)

        eventChannel =
            EventChannel(
                binding.binaryMessenger,
                HEART_RATE_CHANNEL,
            ).apply { setStreamHandler(this@HeartRatePlugin) }
        sensorBatchChannel =
            EventChannel(binding.binaryMessenger, SENSOR_BATCH_CHANNEL).apply {
                setStreamHandler(sensorBatchStreamHandler)
            }

        methodChannel =
            MethodChannel(
                binding.binaryMessenger,
                HEART_RATE_STATUS_CHANNEL,
            ).apply { setMethodCallHandler(this@HeartRatePlugin) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        releaseEventSink()
        releaseSensorBatchSink()
        applicationContext = null
        eventChannel?.setStreamHandler(null)
        sensorBatchChannel?.setStreamHandler(null)
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

    private fun releaseSensorBatchSink() {
        sensorBatchSink?.let { sensorBatchSinks.remove(it) }
        sensorBatchSink = null
    }

    /**
     * 남아 있는 /imu/batch/·/imu/dropped/ DataItem 을 seq 오름차순으로 sink 에 넘기고 지운다.
     * getDataItems 콜백은 백그라운드 스레드일 수 있어 sendSensorBatch 안에서 메인으로 넘어간다.
     */
    private fun drainPendingImuItems() {
        val context = applicationContext ?: return
        val dataClient = Wearable.getDataClient(context)
        dataClient
            .getDataItems(Uri.parse("wear://*$IMU_PREFIX"), DataClient.FILTER_PREFIX)
            .addOnSuccessListener { buffer ->
                val pending =
                    try {
                        buffer
                            .mapNotNull { item ->
                                val json = imuItemToJson(item) ?: return@mapNotNull null
                                Triple(imuItemSeq(item), item.uri, json)
                            }.sortedBy { it.first }
                    } finally {
                        buffer.release()
                    }
                if (pending.isEmpty()) return@addOnSuccessListener
                Log.d("Widyu", "Replaying ${pending.size} pending IMU items")
                pending.forEach { (_, uri, json) ->
                    if (sendSensorBatch(json)) dataClient.deleteDataItems(uri)
                }
            }.addOnFailureListener { Log.w("Widyu", "Failed to read pending IMU items", it) }
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
        private const val SENSOR_BATCH_CHANNEL = "com.gbable.widu/sensor_batch"
        private const val HEART_RATE_STATUS_CHANNEL = "com.gbable.widu/heart_rate_status"
        private const val HEART_RATE_KEY = "heartRate"
        private const val TIMESTAMP_KEY = "timestamp"
        private const val HEART_RATE_STATUS_KEY = "heartRateStatus"
        private const val HEART_RATE_STATUS_PATH = "/heart_rate_status"
        private const val IMU_PREFIX = "/imu/"
        private const val IMU_BATCH_PREFIX = "/imu/batch/"
        private const val IMU_DROPPED_PREFIX = "/imu/dropped/"
        private const val SEQ_KEY = "seq"
        private const val BODY_KEY = "body"
        private const val SESSION_ID_KEY = "session_id"
        private const val FROM_SEQ_KEY = "from_seq"
        private const val TO_SEQ_KEY = "to_seq"
        private const val REASON_KEY = "reason"
        private const val TS_MS_KEY = "ts_ms"

        // Data Layer 콜백 스레드에서 등록·해제되고 메인 스레드에서 순회되므로
        // 동시 접근에 안전한 컬렉션을 사용한다.
        private val eventSinks = CopyOnWriteArraySet<EventChannel.EventSink>()
        private val sensorBatchSinks = CopyOnWriteArraySet<EventChannel.EventSink>()

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

        /**
         * DataItem 을 Flutter 로 보낼 JSON 문자열로 바꾼다. IMU 항목이 아니거나 body 가 없으면 null.
         * 서비스와 onListen 재전달이 같은 변환을 쓰도록 여기 한 곳에만 둔다.
         */
        fun imuItemToJson(item: DataItem): String? {
            val path = item.uri.path.orEmpty()
            val dataMap = DataMapItem.fromDataItem(item).dataMap
            return when {
                path.startsWith(IMU_BATCH_PREFIX) ->
                    dataMap.getByteArray(BODY_KEY)?.let { String(it, StandardCharsets.UTF_8) }

                path.startsWith(IMU_DROPPED_PREFIX) ->
                    JSONObject()
                        .put("stream", "imu_dropped")
                        .put("session_id", dataMap.getString(SESSION_ID_KEY))
                        .put("from_seq", dataMap.getLong(FROM_SEQ_KEY))
                        .put("to_seq", dataMap.getLong(TO_SEQ_KEY))
                        .put("reason", dataMap.getString(REASON_KEY))
                        .put("ts_ms", dataMap.getLong(TS_MS_KEY))
                        .toString()

                else -> null
            }
        }

        /** dropped 항목에는 seq 가 없어 from_seq 로 대신 정렬한다. */
        private fun imuItemSeq(item: DataItem): Long {
            val dataMap = DataMapItem.fromDataItem(item).dataMap
            return if (dataMap.containsKey(SEQ_KEY)) dataMap.getLong(SEQ_KEY) else dataMap.getLong(FROM_SEQ_KEY)
        }

        /**
         * sink 가 하나도 없으면 전달되지 않았음을 알리려고 false 를 돌려준다.
         * 호출자는 이때 DataItem 을 남겨 두어 엔진이 살아난 뒤 다시 읽게 한다.
         */
        fun sendSensorBatch(json: String): Boolean {
            if (sensorBatchSinks.isEmpty()) return false
            Handler(Looper.getMainLooper()).post {
                sensorBatchSinks.forEach { sink ->
                    try {
                        sink.success(json)
                    } catch (e: Exception) {
                        sensorBatchSinks.remove(sink)
                        Log.e("HeartRatePlugin", "Error sending sensor batch to sink", e)
                    }
                }
            }
            return true
        }
    }
}
