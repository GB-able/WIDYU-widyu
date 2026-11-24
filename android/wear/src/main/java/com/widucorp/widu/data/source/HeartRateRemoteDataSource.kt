package com.widucorp.widu.data.source

import com.widucorp.widu.data.model.HeartRateBatch
import com.widucorp.widu.data.model.HeartRateStatus
import kotlinx.coroutines.flow.Flow

/** 배치 전송·정리·기록은 실패를 예외로 던지지 않고 로그만 남긴다(취소는 전파). */
interface HeartRateRemoteDataSource {
    /** `/hr/batch/<sessionId>/<seq>` 로 보낸다. 도착 지연 예산(A 1.1.8)이 짧아 즉시 동기화한다. */
    suspend fun sendBatch(batch: HeartRateBatch): Boolean

    /** 쌓인 배치가 [maxItems] 를 넘으면 오래된 것부터 지우고 지운 seq 를 돌려준다. */
    suspend fun trimQueue(
        sessionId: String,
        maxItems: Int,
    ): List<Long>

    /** 버린 구간을 `/hr/dropped/<sessionId>/<fromSeq>` 로 기록한다. [reason] 은 `DropReason` 값. */
    suspend fun recordDrop(
        sessionId: String,
        fromSeq: Long,
        toSeq: Long,
        reason: String,
    )

    fun fetchHeartRateStatus(): Flow<HeartRateStatus>
}
