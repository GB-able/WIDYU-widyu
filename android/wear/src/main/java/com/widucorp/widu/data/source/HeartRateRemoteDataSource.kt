package com.widucorp.widu.data.source

import com.widucorp.widu.data.model.HeartRateBatch
import com.widucorp.widu.data.model.HeartRateStatus
import kotlinx.coroutines.flow.Flow

interface HeartRateRemoteDataSource {
    /** 폰 화면의 연결·착용 표시용 최신 값. 서버 전송은 [sendBatch] 가 한다. */
    fun sendHeartRate(heartRate: Int)

    /** `/hr/batch/<sessionId>/<seq>` 로 보낸다. 도착 지연 예산(A 1.1.8)이 짧아 즉시 동기화한다. */
    suspend fun sendBatch(batch: HeartRateBatch)

    /** 쌓인 배치가 [maxItems] 를 넘으면 오래된 것부터 지우고 지운 seq 를 돌려준다. */
    suspend fun trimQueue(
        sessionId: String,
        maxItems: Int,
    ): List<Long>

    fun fetchHeartRateStatus(): Flow<HeartRateStatus>
}
