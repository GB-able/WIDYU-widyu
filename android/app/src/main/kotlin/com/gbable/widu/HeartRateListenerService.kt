package com.gbable.widu

import android.util.Log
import com.gbable.widu.heart_rate.HeartRatePlugin
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataItem
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.Wearable
import com.google.android.gms.wearable.WearableListenerService
import org.json.JSONObject
import java.nio.charset.StandardCharsets

class HeartRateListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        dataEvents.forEach { event ->
            if (event.type == DataEvent.TYPE_CHANGED) {
                val item = event.dataItem
                val path = item.uri.path.orEmpty()
                val dataMap = DataMapItem.fromDataItem(item).dataMap
                when {
                    path == HEART_RATE_PATH -> {
                        HeartRatePlugin.sendHeartRate(dataMap.getInt(HEART_RATE_KEY), dataMap.getLong(TIMESTAMP_KEY))
                    }
                    path.startsWith(IMU_BATCH_PREFIX) -> {
                        val body = dataMap.getByteArray(BODY_KEY)
                        if (body == null) {
                            Log.w(TAG, "IMU batch body missing path=$path")
                            consume(item)
                            return@forEach
                        }
                        val json = String(body, StandardCharsets.UTF_8)
                        HeartRatePlugin.sendSensorBatch(json)
                        Log.d(TAG, "IMU received seq=${dataMap.getLong(SEQ_KEY)} path=$path")
                        consume(item)
                    }
                    path.startsWith(IMU_DROPPED_PREFIX) -> {
                        HeartRatePlugin.sendSensorBatch(
                            JSONObject()
                                .put("stream", "imu_dropped")
                                .put("session_id", dataMap.getString(SESSION_ID_KEY))
                                .put("from_seq", dataMap.getLong(FROM_SEQ_KEY))
                                .put("to_seq", dataMap.getLong(TO_SEQ_KEY))
                                .put("reason", dataMap.getString(REASON_KEY))
                                .put("ts_ms", dataMap.getLong(TS_MS_KEY))
                                .toString(),
                        )
                        Log.d(TAG, "IMU dropped from=${dataMap.getLong(FROM_SEQ_KEY)} to=${dataMap.getLong(TO_SEQ_KEY)}")
                        consume(item)
                    }
                }
            }
        }
    }

    /** 소비 완료 표시. 지우지 않으면 워치 쪽 큐가 줄지 않는다. */
    private fun consume(item: DataItem) {
        Wearable.getDataClient(this).deleteDataItems(item.uri)
    }

    companion object {
        private const val TAG = "Widyu"
        private const val HEART_RATE_PATH = "/heart_rate"
        private const val HEART_RATE_KEY = "heart_rate"
        private const val TIMESTAMP_KEY = "timestamp"
        private const val IMU_BATCH_PREFIX = "/imu/batch/"
        private const val IMU_DROPPED_PREFIX = "/imu/dropped/"
        private const val SEQ_KEY = "seq"
        private const val BODY_KEY = "body"
        private const val SESSION_ID_KEY = "session_id"
        private const val FROM_SEQ_KEY = "from_seq"
        private const val TO_SEQ_KEY = "to_seq"
        private const val REASON_KEY = "reason"
        private const val TS_MS_KEY = "ts_ms"
    }
}
