package com.gbable.widu.data.source

import android.net.Uri
import android.util.Log
import com.gbable.widu.data.model.ImuBatch
import com.gbable.widu.data.model.toJson
import com.google.android.gms.tasks.Task
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.PutDataMapRequest
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.suspendCancellableCoroutine
import javax.inject.Inject
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

class ImuRemoteDataSourceImpl @Inject constructor(
    private val dataClient: DataClient,
) : ImuRemoteDataSource {
    override suspend fun sendBatch(
        batch: ImuBatch,
        urgent: Boolean,
    ) {
        // 평시 배치에는 setUrgent() 를 붙이지 않는다. 지연 동기화로 충분하고, 그래야 배터리를 덜 쓴다.
        runSafely("send batch seq=${batch.seq}") {
            val request =
                PutDataMapRequest.create("$BATCH_PREFIX/${batch.sessionId}/${batch.seq}").run {
                    dataMap.putByteArray(KEY_BODY, batch.toJson().toString().toByteArray())
                    dataMap.putLong(KEY_SEQ, batch.seq)
                    dataMap.putLong(KEY_TIMESTAMP, System.currentTimeMillis())
                    asPutDataRequest().apply { if (urgent) setUrgent() }
                }
            dataClient.putDataItem(request).awaitResult()
        }
    }

    override suspend fun trimQueue(
        sessionId: String,
        maxItems: Int,
    ): List<Long> =
        runSafely("trim queue of $sessionId") {
            val buffer = dataClient.getDataItems(queueUri(sessionId), DataClient.FILTER_PREFIX).awaitResult()
            val queued =
                try {
                    buffer.map { DataMapItem.fromDataItem(it).dataMap.getLong(KEY_SEQ) to it.uri }.sortedBy { it.first }
                } finally {
                    buffer.release()
                }

            val excess = queued.size - maxItems
            if (excess <= 0) return@runSafely emptyList()

            queued.take(excess).map { (seq, uri) ->
                dataClient.deleteDataItems(uri).awaitResult()
                seq
            }
        } ?: emptyList()

    override suspend fun recordDrop(
        sessionId: String,
        fromSeq: Long,
        toSeq: Long,
    ) {
        runSafely("record drop $fromSeq..$toSeq") {
            val request =
                PutDataMapRequest.create("$DROPPED_PREFIX/$sessionId/$fromSeq").run {
                    dataMap.putString(KEY_SESSION_ID, sessionId)
                    dataMap.putLong(KEY_FROM_SEQ, fromSeq)
                    dataMap.putLong(KEY_TO_SEQ, toSeq)
                    // 결측 사유 값 목록은 미정(정책서 S2). 합의되면 그 열거형으로 교체한다.
                    dataMap.putString(KEY_REASON, REASON_QUEUE_OVERFLOW)
                    dataMap.putLong(KEY_TS_MS, System.currentTimeMillis())
                    asPutDataRequest()
                }
            dataClient.putDataItem(request).awaitResult()
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

    private fun queueUri(sessionId: String): Uri = Uri.parse("wear://*$BATCH_PREFIX/$sessionId")

    private companion object {
        const val TAG = "Widyu"
        const val BATCH_PREFIX = "/imu/batch"
        const val DROPPED_PREFIX = "/imu/dropped"
        const val KEY_BODY = "body"
        const val KEY_SEQ = "seq"
        const val KEY_TIMESTAMP = "timestamp"
        const val KEY_SESSION_ID = "session_id"
        const val KEY_FROM_SEQ = "from_seq"
        const val KEY_TO_SEQ = "to_seq"
        const val KEY_REASON = "reason"
        const val KEY_TS_MS = "ts_ms"
        const val REASON_QUEUE_OVERFLOW = "queue_overflow"
    }
}

/** kotlinx-coroutines-play-services 를 더 들이지 않으려고 직접 감싼다. */
private suspend fun <T> Task<T>.awaitResult(): T =
    suspendCancellableCoroutine { continuation ->
        addOnCompleteListener { task ->
            val exception = task.exception
            when {
                exception != null -> continuation.resumeWithException(exception)
                task.isCanceled -> continuation.cancel()
                else -> continuation.resume(task.result)
            }
        }
    }
