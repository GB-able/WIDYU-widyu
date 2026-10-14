package com.gbable.widu.data.model

/** 앞쪽 7개 필드는 서버 `GET /api/v1/sensor/config` 값(폰이 `/imu/config` 로 전달), 나머지는 서버 스펙에 없어 기본값이다. */
data class ImuConfig(
    val accHz: Int = 50,
    val batchSec: Int = 1,
    /** `continuous` / `trigger` 둘뿐이고 끄는 값은 없다(A 1.6.4). 동작 차이가 미정이라 배치에 에코만 한다. */
    val gyroMode: String = "continuous",
    val collectionMode: String = "product",
    val impactG: Float = 1.8f,
    val backfillPreSec: Int = 2,
    val backfillPostSec: Int = 10,
    val anchorIntervalMin: Int = 10,
    val queueMinutes: Int = 10,
    /** 이 배수의 seq 마다 큐 길이를 정리한다. */
    val trimEverySeq: Int = 30,
    val clockJumpToleranceMs: Double = 50.0,
)

/** 낙상 판정이 아니라 「이 구간의 자이로를 빠뜨리지 말라」는 신호다. (A 1.6.4) */
data class ImpactTrigger(
    val kind: String = "impact",
    val smvG: Float,
    val eventElapsedNs: Long,
    val tsMs: Long,
)

/** 자이로 결측 사유 (A 1.2.6). 값 목록은 정책서 합의 대기(S2). */
object MissingReason {
    const val OMITTED_BY_MODE = "omitted_by_mode"
    const val SENSOR_UNSUPPORTED = "sensor_unsupported"
    const val PERMISSION_DENIED = "permission_denied"
    const val MISSING = "missing"
}

data class ImuSample(
    val type: Type,
    val timestampNs: Long,
    val x: Float,
    val y: Float,
    val z: Float,
) {
    enum class Type { ACC, GYRO }
}

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
