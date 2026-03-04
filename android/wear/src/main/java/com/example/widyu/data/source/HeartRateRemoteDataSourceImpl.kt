package com.example.widyu.data.source

import android.util.Log
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.PutDataMapRequest
import javax.inject.Inject

class HeartRateRemoteDataSourceImpl @Inject constructor(
    private val dataClient: DataClient,
) : HeartRateRemoteDataSource {
    override fun sendHeartRate(heartRate: Int) {
        val putDataReq =
            PutDataMapRequest.create(REQUEST_PATH).run {
                dataMap.putInt(HEART_RATE_KEY, heartRate)
                dataMap.putLong(TIMESTAMP_KEY, System.currentTimeMillis())
                asPutDataRequest().setUrgent()
            }

        dataClient
            .putDataItem(putDataReq)
            .addOnFailureListener { e ->
                Log.i("Widyu", "Error sending request to device", e)
            }
    }

    companion object {
        private const val REQUEST_PATH = "/widyu_request"
        private const val HEART_RATE_KEY = "heart_rate"
        private const val TIMESTAMP_KEY = "timestamp"
    }
}
