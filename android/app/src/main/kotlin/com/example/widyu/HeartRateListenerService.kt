package com.example.widyu

import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.WearableListenerService

class HeartRateListenerService : WearableListenerService() {
    private val heartRateChannelManager: HeartRateChannelManager by lazy { (application as App).heartRateChannelManager }

    override fun onDataChanged(dataEvents: DataEventBuffer) {
        dataEvents.forEach { event ->
            if (event.type == DataEvent.TYPE_CHANGED) {
                val item = event.dataItem
                if (item.uri.path == HEART_RATE_PATH) {
                    val dataMap = DataMapItem.fromDataItem(item).dataMap
                    val heartRate = dataMap.getInt(HEART_RATE_KEY)
                    val timestamp = dataMap.getLong(TIMESTAMP_KEY)
                    heartRateChannelManager.sendHeartRate(heartRate, timestamp)
                }
            }
        }
    }

    companion object {
        private const val HEART_RATE_PATH = "/heart_rate"
        private const val HEART_RATE_KEY = "heart_rate"
        private const val TIMESTAMP_KEY = "timestamp"
    }
}
