package com.widucorp.widu.data.util

import android.net.Uri
import com.google.android.gms.tasks.Task
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.PutDataMapRequest
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException

/*
 * 배치마다 고유 경로(`<prefix>/<sessionId>/<seq>`)의 DataItem 을 두어 Data Layer 저장소를 큐로 쓴다.
 * DataItem 은 폰과 끊겨도 워치에 남아 있다가 재연결 시 동기화된다. 폰은 서버가 받은 뒤에 지운다.
 */

private const val KEY_BODY = "body"
private const val KEY_SEQ = "seq"
private const val KEY_TIMESTAMP = "timestamp"

internal suspend fun DataClient.putBatch(
    prefix: String,
    sessionId: String,
    seq: Long,
    body: ByteArray,
    urgent: Boolean,
) {
    val request =
        PutDataMapRequest.create("$prefix/$sessionId/$seq").run {
            dataMap.putByteArray(KEY_BODY, body)
            dataMap.putLong(KEY_SEQ, seq)
            dataMap.putLong(KEY_TIMESTAMP, System.currentTimeMillis())
            asPutDataRequest().apply { if (urgent) setUrgent() }
        }
    putDataItem(request).awaitResult()
}

/** 쌓인 항목이 [maxItems] 를 넘으면 seq 가 작은 것부터 지우고, 지운 seq 를 오름차순으로 돌려준다. */
internal suspend fun DataClient.trimOldest(
    prefix: String,
    sessionId: String,
    maxItems: Int,
): List<Long> {
    val buffer = getDataItems(Uri.parse("wear://*$prefix/$sessionId"), DataClient.FILTER_PREFIX).awaitResult()
    val queued =
        try {
            // 상한이 1800개라 매번 본문(DataMap)을 풀지 않고 경로 끝의 seq 만 읽는다.
            buffer.mapNotNull { item -> item.uri.lastPathSegment?.toLongOrNull()?.let { it to item.uri } }.sortedBy { it.first }
        } finally {
            buffer.release()
        }
    val excess = queued.size - maxItems
    if (excess <= 0) return emptyList()
    return queued.take(excess).map { (seq, uri) ->
        deleteDataItems(uri).awaitResult()
        seq
    }
}

/** kotlinx-coroutines-play-services 를 더 들이지 않으려고 직접 감싼다. */
internal suspend fun <T> Task<T>.awaitResult(): T =
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
