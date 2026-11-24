package com.widucorp.widu.data.model

/**
 * 앞쪽 2개 필드만 서버 `GET /api/v1/sensor/config` 값(폰이 `/imu/config` 로 전달)을 따른다.
 * 측정 주기·배치 길이는 배터리 시험으로 정한 값이라 서버 값을 받지 않는다.
 */
data class ImuConfig(
    /** 자이로는 수집하지 않는다. 서버 스펙 필드라 배치에 에코만 한다. */
    val gyroMode: String = "continuous",
    val collectionMode: String = "product",
    val accHz: Int = 50,
    /** 센서 FIFO 지연(maxReportLatency)도 이 값이다. */
    val batchSec: Int = 5,
    val anchorIntervalMin: Int = 10,
    /** 폰도 이 항목을 서버 결과 전까지 지우지 않으므로 폰 오프라인 보관 한도(계약 §1, 30분 이상)와 같다. */
    val queueMinutes: Int = 30,
    /** 이 배수의 seq 마다 큐 길이를 정리한다. */
    val trimEverySeq: Int = 30,
    val clockJumpToleranceMs: Double = 50.0,
)

/** 가속도 샘플(m/s²). */
data class ImuSample(
    val timestampNs: Long,
    val x: Float,
    val y: Float,
    val z: Float,
)

/** 단조 시각(부팅 기준)을 벽시계로 환산하기 위한 기준점. */
data class ClockInfo(
    val bootId: String,
    val clockMappingId: String,
    val anchorElapsedNs: Long,
    val anchorEpochMs: Long,
    val uncertaintyMs: Double,
)

data class ClockAnchor(
    val elapsedNs: Long,
    val epochMs: Long,
    val uncertaintyMs: Double,
)

/** 시각은 [t0ElapsedNs] 과 간격 [dtNs](n-1개)로만 표현한다 — 등간격을 가정해 되계산하지 않는다. */
data class AxisSeries(
    val fsHzRequested: Int,
    val t0ElapsedNs: Long,
    val dtNs: LongArray,
    val values: List<IntArray>,
) {
    val n: Int get() = values.size

    init {
        require(values.isNotEmpty()) { "AxisSeries must not be empty" }
        require(dtNs.size == values.size - 1) { "dt_ns must have n-1 entries" }
    }

    override fun equals(other: Any?): Boolean = this === other

    override fun hashCode(): Int = System.identityHashCode(this)
}
