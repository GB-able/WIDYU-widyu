package com.example.widyu.data.source

import android.content.Context
import android.util.Log
import com.example.widyu.data.model.HeartRateStatus
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import javax.inject.Inject

class HeartRateRemoteDataSourceImpl @Inject constructor(
    @ApplicationContext context: Context,
) : HeartRateRemoteDataSource {
    private val dataClient: DataClient by lazy { Wearable.getDataClient(context) }
    private val messageClient: MessageClient by lazy { Wearable.getMessageClient(context) }

    override fun sendHeartRate(heartRate: Int) {
        val putDataReq =
            PutDataMapRequest.create(HEART_RATE_PATH).run {
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

    override fun fetchHeartRateStatus(): Flow<HeartRateStatus> =
        callbackFlow {
            val listener =
                MessageClient.OnMessageReceivedListener { messageEvent ->
                    if (messageEvent.path == HEART_RATE_STATUS_PATH) {
                        val data = String(messageEvent.data)
                        val heartRateStatus = HeartRateStatus.from(data)
                        trySend(heartRateStatus)
                    }
                }

            messageClient.addListener(listener)

            awaitClose { messageClient.removeListener(listener) }
        }

    companion object {
        private const val HEART_RATE_PATH = "/heart_rate"
        private const val HEART_RATE_STATUS_PATH = "/heart_rate_status"
        private const val HEART_RATE_KEY = "heart_rate"
        private const val TIMESTAMP_KEY = "timestamp"
    }
}
