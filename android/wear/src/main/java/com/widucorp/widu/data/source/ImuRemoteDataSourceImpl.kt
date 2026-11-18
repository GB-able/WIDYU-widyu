package com.widucorp.widu.data.source

import android.util.Log
import com.widucorp.widu.data.model.ImuBatch
import com.widucorp.widu.data.model.toJson
import com.widucorp.widu.data.util.putBatch
import com.widucorp.widu.data.util.putDrop
import com.widucorp.widu.data.util.trimOldest
import com.google.android.gms.wearable.DataClient
import kotlinx.coroutines.CancellationException
import javax.inject.Inject

class ImuRemoteDataSourceImpl @Inject constructor(
    private val dataClient: DataClient,
) : ImuRemoteDataSource {
    override suspend fun sendBatch(
        batch: ImuBatch,
        urgent: Boolean,
    ): Boolean =
        // 평시 배치에는 setUrgent() 를 붙이지 않는다. 지연 동기화로 충분하고, 그래야 배터리를 덜 쓴다.
        runSafely("send batch seq=${batch.seq}") {
            dataClient.putBatch(BATCH_PREFIX, batch.sessionId, batch.seq, batch.toJson().toString().toByteArray(), urgent)
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
            Log.w(TAG, "Failed to $what", exception)
            null
        }

    private companion object {
        const val TAG = "Widyu"
        const val BATCH_PREFIX = "/imu/batch"
        const val DROPPED_PREFIX = "/imu/dropped"
        const val DROPPED_STREAM = "imu_watch"
    }
}
