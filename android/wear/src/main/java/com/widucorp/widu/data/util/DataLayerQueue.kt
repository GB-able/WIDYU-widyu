package com.widucorp.widu.data.util

import android.net.Uri
import android.util.Log
import com.google.android.gms.tasks.Task
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.PutDataMapRequest
import kotlinx.coroutines.CancellationException
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
private const val KEY_DROPPED_STREAM = "dropped_stream"
private const val KEY_SESSION_ID = "session_id"
private const val KEY_FROM_SEQ = "from_seq"
private const val KEY_TO_SEQ = "to_seq"
private const val KEY_REASON = "reason"
private const val KEY_TS_MS = "ts_ms"

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
    SendStats.record(body.size)
}

/**
 * 버린 배치 구간 하나를 `<prefix>/<sessionId>/<fromSeq>` 항목으로 남긴다. 폰이 서버 `stream: "dropped"` 기록으로 바꿔 올린다.
 * 조용히 사라지면 서버가 결측 구간을 "기록 없음" 으로 적어 미착용·전송 실패와 구별하지 못한다.
 */
internal suspend fun DataClient.putDrop(
    prefix: String,
    droppedStream: String,
    sessionId: String,
    fromSeq: Long,
    toSeq: Long,
    reason: String,
) {
    val request =
        PutDataMapRequest.create("$prefix/$sessionId/$fromSeq").run {
            dataMap.putString(KEY_DROPPED_STREAM, droppedStream)
            dataMap.putString(KEY_SESSION_ID, sessionId)
            dataMap.putLong(KEY_FROM_SEQ, fromSeq)
            dataMap.putLong(KEY_TO_SEQ, toSeq)
            dataMap.putString(KEY_REASON, reason)
            dataMap.putLong(KEY_TS_MS, System.currentTimeMillis())
            asPutDataRequest()
        }
    putDataItem(request).awaitResult()
}

/** 서버와 합의한 버린 사유 값. 서버는 목록 밖 값도 저장하므로 늘릴 때는 여기와 규격 문서만 고친다. */
object DropReason {
    /** 대기열 상한을 넘어 오래된 배치부터 지웠다. */
    const val QUEUE_OVERFLOW = "queue_overflow"

    /** 배치를 Data Layer 대기열에 넣지 못했다. 그 배치 하나라 from_seq = to_seq 다. */
    const val ENQUEUE_FAILED = "enqueue_failed"
}

/** Data Layer 에 넘긴 배치 수·바이트. 연구 모드 SENT_TO_PHONE 이 주기마다 비워 간다. 실제 블루투스 전송 시각은 앱이 알 수 없다. */
object SendStats {
    private var count = 0
    private var bytes = 0L

    @Synchronized
    fun record(size: Int) {
        count++
        bytes += size
    }

    /** 쌓인 값을 돌려주고 0 으로 되돌린다. */
    @Synchronized
    fun drain(): Pair<Int, Long> = (count to bytes).also {
        count = 0
        bytes = 0
    }
}

/**
 * 쌓인 항목이 [maxItems] 를 넘으면 seq 가 작은 것부터 지우고, 지운 seq 를 오름차순으로 돌려준다.
 * 중간에 삭제가 실패하면 거기서 멈추고 그때까지 지운 seq 를 돌려준다 — 이미 지운 것은 버린 구간으로 기록돼야 한다.
 */
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
    val deleted = mutableListOf<Long>()
    for ((seq, uri) in queued.take(excess)) {
        try {
            deleteDataItems(uri).awaitResult()
        } catch (exception: CancellationException) {
            throw exception
        } catch (exception: Exception) {
            Log.w("Widyu", "Failed to trim $uri", exception)
            break
        }
        deleted += seq
    }
    return deleted
}

/**
 * 오름차순 seq 를 연속 구간으로 나눈다. `[0, 1, 2, 5]` → `[0..2, 5..5]`.
 * 폰이 중간 seq 를 먼저 지웠거나 대기열에 못 넣은 seq 가 끼어 있으면 버린 seq 가 띄엄띄엄이다.
 * 한 구간으로 묶으면 서버가 받은 seq 까지 버린 것으로 적힌다.
 */
internal fun List<Long>.toRanges(): List<LongRange> =
    fold(mutableListOf()) { ranges, seq ->
        val last = ranges.lastOrNull()
        if (last != null && seq == last.last + 1) ranges[ranges.lastIndex] = last.first..seq else ranges += seq..seq
        ranges
    }

/** Data Layer 호출 실패가 수집 흐름을 끊지 않게 로그만 남기고 null 을 돌려준다. 취소만 그대로 올려 보낸다. */
internal inline fun <T> runSafely(
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
