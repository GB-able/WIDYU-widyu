package com.gbable.widu.data.source

import android.util.Log
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.PutDataMapRequest
import javax.inject.Inject

class FallEventRemoteDataSourceImpl @Inject constructor(
    private val dataClient: DataClient,
) : FallEventRemoteDataSource {
    override fun sendFallEvent(eventTimeEpochMs: Long) {
        val putDataReq =
            PutDataMapRequest.create(FALL_EVENT_PATH).run {
                dataMap.putLong(EVENT_TIME_KEY, eventTimeEpochMs)
                dataMap.putLong(TIMESTAMP_KEY, System.currentTimeMillis())
                asPutDataRequest().setUrgent()
            }
        dataClient
            .putDataItem(putDataReq)
            .addOnFailureListener { e ->
                Log.i("Widyu", "Error sending fall event to device", e)
            }
    }

    companion object {
        private const val FALL_EVENT_PATH = "/fall_event"
        private const val EVENT_TIME_KEY = "event_time"
        private const val TIMESTAMP_KEY = "timestamp"
    }
}
