package com.widucorp.widu.data.source

import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.PutDataMapRequest
import com.widucorp.widu.data.model.ImuBatch
import com.widucorp.widu.data.model.toJson
import com.widucorp.widu.data.util.putBatch
import com.widucorp.widu.data.util.putDrop
import com.widucorp.widu.data.util.runSafely
import com.widucorp.widu.data.util.trimOldest
import javax.inject.Inject

class ImuRemoteDataSourceImpl @Inject constructor(
    private val dataClient: DataClient,
) : ImuRemoteDataSource {
    override suspend fun sendBatch(batch: ImuBatch): Boolean =
        // SendGate 가 심박과 같은 순간으로 모아 보내므로 바로 동기화한다. 미루면 블루투스가 따로 깨어 모은 의미가 없다.
        runSafely("send batch seq=${batch.seq}") {
            dataClient.putBatch(BATCH_PREFIX, batch.sessionId, batch.seq, batch.toJson().toString().toByteArray(), urgent = true)
        } != null

    override suspend fun trimQueue(
        sessionId: String,
        maxItems: Int,
    ): List<Long> = runSafely("trim queue of $sessionId") { dataClient.trimOldest(BATCH_PREFIX, sessionId, maxItems) } ?: emptyList()

    override suspend fun recordDrop(
        sessionId: String,
        fromSeq: Long,
        toSeq: Long,
        reason: String,
    ) {
        runSafely("record drop $fromSeq..$toSeq ($reason)") {
            dataClient.putDrop(DROPPED_PREFIX, DROPPED_STREAM, sessionId, fromSeq, toSeq, reason)
        }
    }

    private companion object {
        const val BATCH_PREFIX = "/imu/batch"
        const val DROPPED_PREFIX = "/imu/dropped"
        const val DROPPED_STREAM = "imu_watch"
    }
}
