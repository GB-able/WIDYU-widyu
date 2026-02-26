package com.example.widyu.data.source

import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.PutDataMapRequest
import javax.inject.Inject

class HeartRateRemoteDataSourceImpl @Inject constructor(
    private val dataClient: DataClient,
) : HeartRateRemoteDataSource {
    override suspend fun sendHeartRate(heartRate: Double) {
        try {
            val putDataMapReq =
                PutDataMapRequest.create("/heart_rate").apply {
                    dataMap.putDouble("value", heartRate)
                    dataMap.putLong("timestamp", System.currentTimeMillis())
                }
            val putDataReq = putDataMapReq.asPutDataRequest().setUrgent()
//            dataClient.putDataItem(putDataReq).await()
        } catch (e: Exception) {
            // Handle transmission errors
            e.printStackTrace()
        }
    }
}
