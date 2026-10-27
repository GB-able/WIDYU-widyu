package com.widucorp.widu.data.source

import com.widucorp.widu.data.model.ImuBatch

/**
 * IMU 배치를 폰으로 넘긴다.
 *
 * 자체 큐는 두지 않는다. Data Layer 의 DataItem 은 폰과 끊겨도 워치에 남아 있다가
 * 재연결 시 동기화되므로, 배치마다 고유 경로(`/imu/batch/<sessionId>/<seq>`)를 주어
 * 항목이 각각 보존되게 하고 그것을 큐로 쓴다.
 */
interface ImuRemoteDataSource {
    /** [urgent] 면 동기화를 미루지 않는다 — 충격·보강 배치는 즉시 보낸다. (A 1.6.4) */
    suspend fun sendBatch(
        batch: ImuBatch,
        urgent: Boolean = false,
    )

    /**
     * 쌓인 배치가 [maxItems] 를 넘으면 오래된 것부터 지운다.
     * @return 지운 배치의 seq 목록(오름차순). 지운 것이 없으면 빈 목록.
     */
    suspend fun trimQueue(
        sessionId: String,
        maxItems: Int,
    ): List<Long>

    /** 큐 넘침으로 버린 구간을 기록한다. 조용히 사라지면 서버가 결측인지 미착용인지 구별할 수 없다. */
    suspend fun recordDrop(
        sessionId: String,
        fromSeq: Long,
        toSeq: Long,
    )
}
