package com.widucorp.widu.data.source

import com.widucorp.widu.data.model.HeartRateBatch
import com.widucorp.widu.data.model.HeartRateStatus
import com.widucorp.widu.data.model.toJson
import com.widucorp.widu.data.util.putBatch
import com.widucorp.widu.data.util.putDrop
import com.widucorp.widu.data.util.runSafely
import com.widucorp.widu.data.util.trimOldest
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.MessageClient
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import javax.inject.Inject

class HeartRateRemoteDataSourceImpl @Inject constructor(
    private val dataClient: DataClient,
    private val messageClient: MessageClient,
) : HeartRateRemoteDataSource {
    override suspend fun sendBatch(batch: HeartRateBatch): Boolean =
        runSafely("send heart rate batch seq=${batch.seq}") {
            dataClient.putBatch(BATCH_PREFIX, batch.sessionId, batch.seq, batch.toJson().toString().toByteArray(), urgent = true)
        } != null

    override suspend fun trimQueue(
        sessionId: String,
        maxItems: Int,
    ): List<Long> = runSafely("trim heart rate queue of $sessionId") { dataClient.trimOldest(BATCH_PREFIX, sessionId, maxItems) } ?: emptyList()

    override suspend fun recordDrop(
        sessionId: String,
        fromSeq: Long,
        toSeq: Long,
        reason: String,
    ) {
        runSafely("record heart rate drop $fromSeq..$toSeq ($reason)") {
            dataClient.putDrop(DROPPED_PREFIX, DROPPED_STREAM, sessionId, fromSeq, toSeq, reason)
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
        private const val BATCH_PREFIX = "/hr/batch"
        private const val DROPPED_PREFIX = "/hr/dropped"
        private const val DROPPED_STREAM = "hr"
        private const val HEART_RATE_STATUS_PATH = "/heart_rate_status"
    }
}
