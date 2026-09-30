package com.gbable.widu

import android.util.Log
import com.gbable.widu.heart_rate.HeartRatePlugin
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataItem
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.Wearable
import com.google.android.gms.wearable.WearableListenerService

class HeartRateListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        dataEvents.forEach { event ->
            if (event.type == DataEvent.TYPE_CHANGED) {
                val item = event.dataItem
                val path = item.uri.path.orEmpty()
                when {
                    path == HEART_RATE_PATH -> {
                        val dataMap = DataMapItem.fromDataItem(item).dataMap
                        HeartRatePlugin.sendHeartRate(dataMap.getInt(HEART_RATE_KEY), dataMap.getLong(TIMESTAMP_KEY))
                    }
                    path.startsWith(IMU_PREFIX) -> {
                        val json = HeartRatePlugin.imuItemToJson(item)
                        if (json == null) {
                            // 변환할 내용이 없는 항목(body 누락 등)은 남겨 둘 이유가 없다.
                            Log.w(TAG, "IMU item has no payload path=$path")
                            consume(item)
                            return@forEach
                        }
                        // Flutter 엔진이 죽어 있으면 지우지 않고 남겨 둔다.
                        // 엔진이 살아나 sink 를 등록할 때 플러그인이 다시 읽어 간다.
                        // 워치 쪽 10분 상한이 오래된 것부터 정리하므로 무한히 쌓이지는 않는다.
                        if (HeartRatePlugin.sendSensorBatch(json)) {
                            Log.d(TAG, "IMU delivered path=$path")
                            consume(item)
                        } else {
                            Log.w(TAG, "No Flutter sink, keeping IMU item path=$path")
                        }
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
        private const val IMU_PREFIX = "/imu/"
    }
}
