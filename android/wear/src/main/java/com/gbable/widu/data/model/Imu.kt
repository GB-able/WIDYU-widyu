package com.gbable.widu.data.model

/**
 * IMU 수집 설정. 수집 관련 상수는 모두 여기서만 읽는다.
 * (추후 F9 에서 서버 설정으로 교체될 자리)
 */
data class ImuConfig(
    val accHz: Int = 50,
    val batchSec: Int = 1,
    val gyroMode: String = "continuous",
    val collectionMode: String = "product",
    val impactG: Float = 1.8f,
    val backfillPreSec: Int = 2,
    val backfillPostSec: Int = 10,
    val anchorIntervalMin: Int = 10,
    val queueMinutes: Int = 10,
    val clockJumpToleranceMs: Double = 50.0,
)

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

/** ClockLocalDataSource 가 측정한 앵커 원시값. */
data class ClockAnchor(
    val elapsedNs: Long,
    val epochMs: Long,
    val uncertaintyMs: Double,
)

/**
 * 한 축 묶음. 첫 샘플 시각 [t0ElapsedNs] 과 샘플 사이 간격 [dtNs](길이 n-1)로 시각을 표현한다.
 * 등간격을 가정해 되계산하지 않는다.
 */
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
