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
import com.google.android.gms.wearable.PutDataMapRequest
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
    private var sensorConfigChannel: MethodChannel? = null
    private var sensorBatchAckChannel: MethodChannel? = null
    private lateinit var nodeClient: NodeClient
    private lateinit var messageClient: MessageClient
    private var applicationContext: Context? = null

    // sink 집합은 두 엔진이 공유하지만 StreamHandler 는 엔진마다 별도라, 자신의 sink 만 회수하려고 들고 있는다.
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
        sensorConfigChannel =
            MethodChannel(binding.binaryMessenger, SENSOR_CONFIG_CHANNEL).apply {
                setMethodCallHandler { call, result ->
                    if (call.method == "applyConfig") {
                        putSensorConfig(call)
                        result.success(null)
                    } else {
                        result.notImplemented()
                    }
                }
            }
        sensorBatchAckChannel =
            MethodChannel(binding.binaryMessenger, SENSOR_BATCH_ACK_CHANNEL).apply {
                setMethodCallHandler { call, result ->
                    if (call.method == "consume") {
                        consumeSensorItem(call)
                        result.success(null)
                    } else {
                        result.notImplemented()
                    }
                }
            }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        releaseEventSink()
        releaseSensorBatchSink()
        applicationContext = null
        eventChannel?.setStreamHandler(null)
        sensorBatchChannel?.setStreamHandler(null)
        methodChannel?.setMethodCallHandler(null)
        sensorConfigChannel?.setMethodCallHandler(null)
        sensorBatchAckChannel?.setMethodCallHandler(null)
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

    // 다른 엔진의 sink 까지 지우면 그 엔진의 심박수 수신이 영구히 끊긴다.
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

    /** 남아 있는 센서 DataItem(IMU·심박)을 seq 오름차순으로 넘긴다. 지우는 건 서버 결과를 받은 Flutter 가 한다. */
    private fun drainPendingImuItems() {
        val context = applicationContext ?: return
        val dataClient = Wearable.getDataClient(context)
        SENSOR_PREFIXES.forEach { prefix ->
            dataClient
                .getDataItems(Uri.parse("wear://*$prefix"), DataClient.FILTER_PREFIX)
                .addOnSuccessListener { buffer ->
                    val pending =
                        try {
                            buffer
                                .mapNotNull { item ->
                                    val json = sensorItemToJson(item) ?: return@mapNotNull null
                                    sensorItemSeq(item) to json
                                }.sortedBy { it.first }
                        } finally {
                            buffer.release()
                        }
                    if (pending.isEmpty()) return@addOnSuccessListener
                    Log.d("Widyu", "Replaying ${pending.size} pending sensor items under $prefix")
                    pending.forEach { (_, json) -> sendSensorBatch(json) }
                }.addOnFailureListener { Log.w("Widyu", "Failed to read pending sensor items", it) }
        }
    }

    /** 서버가 판정을 내린 항목을 지운다. 경로 규칙(`<prefix><session_id>/<seq>`)은 워치가 정한 것이다. */
    private fun consumeSensorItem(call: MethodCall) {
        val context = applicationContext ?: return
        val prefix =
            when (call.argument<String>("stream")) {
                IMU_STREAM -> IMU_BATCH_PREFIX
                HR_STREAM -> HR_BATCH_PREFIX
                IMU_DROPPED_STREAM -> IMU_DROPPED_PREFIX
                else -> return
            }
        val sessionId = call.argument<String>("session_id") ?: return
        val seq = call.argument<Number>("seq")?.toLong() ?: return
        Wearable
            .getDataClient(context)
            .deleteDataItems(Uri.parse("wear://*$prefix$sessionId/$seq"))
            .addOnFailureListener { Log.w("Widyu", "Failed to consume sensor item", it) }
    }

    /** 키 이름은 워치와의 계약이므로 바꾸지 않는다. 늦게 반영되면 의미가 없어 setUrgent() 로 보낸다. */
    private fun putSensorConfig(call: MethodCall) {
        val context = applicationContext ?: return
        val request =
            PutDataMapRequest.create(IMU_CONFIG_PATH).apply {
                dataMap.putString("collection_mode", call.argument<String>("collection_mode").orEmpty())
                dataMap.putString("gyro_mode", call.argument<String>("gyro_mode").orEmpty())
                dataMap.putInt("acc_hz", call.argument<Int>("acc_hz") ?: 0)
                dataMap.putInt("batch_sec", call.argument<Int>("batch_sec") ?: 0)
                dataMap.putFloat("impact_g", (call.argument<Double>("impact_g") ?: 0.0).toFloat())
                dataMap.putInt("backfill_pre_sec", call.argument<Int>("backfill_pre_sec") ?: 0)
                dataMap.putInt("backfill_post_sec", call.argument<Int>("backfill_post_sec") ?: 0)
                dataMap.putLong("updated_at_ms", System.currentTimeMillis())
            }
        Wearable
            .getDataClient(context)
            .putDataItem(request.asPutDataRequest().setUrgent())
            .addOnFailureListener { Log.w("Widyu", "Failed to put IMU config", it) }
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
        private const val SENSOR_CONFIG_CHANNEL = "com.gbable.widu/sensor_config"
        private const val SENSOR_BATCH_ACK_CHANNEL = "com.gbable.widu/sensor_batch_ack"
        private const val IMU_STREAM = "imu_watch"
        private const val HR_STREAM = "hr"
        private const val IMU_DROPPED_STREAM = "imu_dropped"
        private const val IMU_CONFIG_PATH = "/imu/config"
        private const val IMU_PREFIX = "/imu/"
        private const val IMU_BATCH_PREFIX = "/imu/batch/"
        private const val IMU_DROPPED_PREFIX = "/imu/dropped/"
        private const val HR_BATCH_PREFIX = "/hr/batch/"
        private val SENSOR_PREFIXES = listOf(IMU_PREFIX, "/hr/")
        private const val SEQ_KEY = "seq"
        private const val BODY_KEY = "body"
        private const val SESSION_ID_KEY = "session_id"
        private const val FROM_SEQ_KEY = "from_seq"
        private const val TO_SEQ_KEY = "to_seq"
        private const val REASON_KEY = "reason"
        private const val TS_MS_KEY = "ts_ms"

        // Data Layer 콜백 스레드에서 등록·해제되고 메인 스레드에서 순회된다.
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

        /** 센서 배치 항목이 아니거나 body 가 없으면 null. 서비스와 재전달이 같은 변환을 쓰도록 한 곳에만 둔다. */
        fun sensorItemToJson(item: DataItem): String? {
            val path = item.uri.path.orEmpty()
            val dataMap = DataMapItem.fromDataItem(item).dataMap
            return when {
                path.startsWith(IMU_BATCH_PREFIX) || path.startsWith(HR_BATCH_PREFIX) ->
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
        private fun sensorItemSeq(item: DataItem): Long {
            val dataMap = DataMapItem.fromDataItem(item).dataMap
            return if (dataMap.containsKey(SEQ_KEY)) dataMap.getLong(SEQ_KEY) else dataMap.getLong(FROM_SEQ_KEY)
        }

        /** sink 가 없으면 false — 호출자는 DataItem 을 남겨 두어 엔진이 살아난 뒤 다시 읽게 한다. */
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
