package com.gbable.widu.data.source

import android.util.Log
import com.gbable.widu.data.model.HeartRateBatch
import com.gbable.widu.data.model.HeartRateStatus
import com.gbable.widu.data.model.toJson
import com.gbable.widu.data.util.putBatch
import com.gbable.widu.data.util.trimOldest
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.PutDataMapRequest
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import javax.inject.Inject

class HeartRateRemoteDataSourceImpl @Inject constructor(
    private val dataClient: DataClient,
    private val messageClient: MessageClient,
) : HeartRateRemoteDataSource {
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

    override suspend fun sendBatch(batch: HeartRateBatch) {
        runSafely("send heart rate batch seq=${batch.seq}") {
            dataClient.putBatch(BATCH_PREFIX, batch.sessionId, batch.seq, batch.toJson().toString().toByteArray(), urgent = true)
        }
    }

    override suspend fun trimQueue(
        sessionId: String,
        maxItems: Int,
    ): List<Long> = runSafely("trim heart rate queue of $sessionId") { dataClient.trimOldest(BATCH_PREFIX, sessionId, maxItems) } ?: emptyList()

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

    /** 전송 실패가 수집 흐름을 끊지 않게 한다. 취소만 그대로 올려 보낸다. */
    private inline fun <T> runSafely(
        what: String,
        block: () -> T,
    ): T? =
        try {
            block()
        } catch (exception: CancellationException) {
            throw exception
        } catch (exception: Exception) {
            Log.w("Widyu", "Failed to $what", exception)
            null
        }

    companion object {
        private const val BATCH_PREFIX = "/hr/batch"
        private const val HEART_RATE_PATH = "/heart_rate"
        private const val HEART_RATE_STATUS_PATH = "/heart_rate_status"
        private const val HEART_RATE_KEY = "heart_rate"
        private const val TIMESTAMP_KEY = "timestamp"
    }
}
