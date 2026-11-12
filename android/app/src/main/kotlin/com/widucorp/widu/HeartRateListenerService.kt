package com.widucorp.widu

import android.util.Log
import com.widucorp.widu.heart_rate.HeartRatePlugin
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataItem
import com.google.android.gms.wearable.Wearable
import com.google.android.gms.wearable.WearableListenerService

class HeartRateListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        dataEvents.forEach { event ->
            if (event.type == DataEvent.TYPE_CHANGED) {
                val item = event.dataItem
                val path = item.uri.path.orEmpty()
                when {
                    // 폰이 직접 올린 설정 DataItem 이다. 지우면 워치가 못 읽으므로 손대지 않는다.
                    path == IMU_CONFIG_PATH -> Unit

                    path.startsWith(IMU_PREFIX) || path.startsWith(HR_PREFIX) -> {
                        val json = HeartRatePlugin.sensorItemToJson(item)
                        if (json == null) {
                            // 변환할 내용이 없는 항목(body 누락 등)은 남겨 둘 이유가 없다.
                            Log.w(TAG, "Sensor item has no payload path=$path")
                            consume(item)
                            return@forEach
                        }
                        // 홈 화면 착용 표시와 워치 심박 상태 갱신이 이 신호로 돈다. 엔진 재연결 때의 재전달은 여기를 거치지 않는다.
                        if (path.startsWith(HR_PREFIX)) HeartRatePlugin.sendLatestHeartRate(json)
                        // 넘긴 뒤에도 지우지 않는다. Flutter 가 서버 결과를 받고 지운다(재부팅해도 남아 있게).
                        // 엔진이 죽어 있으면 그대로 두었다가 엔진이 살아난 뒤 다시 읽게 한다.
                        if (HeartRatePlugin.sendSensorBatch(json)) {
                            Log.d(TAG, "Sensor item delivered path=$path")
                        } else {
                            Log.w(TAG, "No Flutter sink, keeping sensor item path=$path")
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
        private const val IMU_PREFIX = "/imu/"
        private const val HR_PREFIX = "/hr/"
        private const val IMU_CONFIG_PATH = "/imu/config"
    }
}
