package com.widucorp.widu.data.util

import com.widucorp.widu.data.model.AxisSeries
import com.widucorp.widu.data.model.ImuSample

/**
 * 샘플을 [batchNs] 길이로 묶는다. Android 의존성 없음.
 *
 * - 첫 샘플 시각이 t0. `ts - t0 >= batchNs` 인 샘플이 오면 현재 배치를 닫고 그 샘플이 다음 배치의 첫 샘플이 된다.
 * - 인접 간격이 [MAX_GAP_NS] 를 넘거나 0 이하면(재부팅·센서 리셋) 그 자리에서 배치를 닫는다.
 */
class ImuBatcher(
    private val batchNs: Long,
    private val fsHzRequested: Int,
) {
    private val timestamps = ArrayList<Long>()
    private val values = ArrayList<IntArray>()

    fun add(sample: ImuSample): AxisSeries? {
        val closed =
            if (timestamps.isEmpty()) {
                null
            } else {
                val gap = sample.timestampNs - timestamps.last()
                if (gap <= 0L || gap > MAX_GAP_NS || sample.timestampNs - timestamps.first() >= batchNs) close() else null
            }
        timestamps += sample.timestampNs
        values += sample.toInts()
        return closed
    }

    /** 서비스 종료 시 남은 샘플을 강제로 내보낸다. */
    fun flush(): AxisSeries? = close()

    private fun close(): AxisSeries? {
        if (timestamps.isEmpty()) return null
        val series =
            AxisSeries(
                fsHzRequested = fsHzRequested,
                t0ElapsedNs = timestamps.first(),
                dtNs = LongArray(timestamps.size - 1) { timestamps[it + 1] - timestamps[it] },
                values = ArrayList(values),
            )
        timestamps.clear()
        values.clear()
        return series
    }

    companion object {
        /** 링버퍼처럼 이미 모아 둔 샘플을 한 배치로 옮긴다. 시각은 원 타임스탬프 그대로 쓴다. */
        fun samplesToSeries(
            samples: List<ImuSample>,
            fsHz: Int,
        ): AxisSeries? {
            if (samples.isEmpty()) return null
            return AxisSeries(
                fsHzRequested = fsHz,
                t0ElapsedNs = samples.first().timestampNs,
                dtNs = LongArray(samples.size - 1) { samples[it + 1].timestampNs - samples[it].timestampNs },
                values = samples.map { it.toInts() },
            )
        }

        /** SensorEvent 배칭이 허용하는 최대 간격(uint32 ns). 이보다 벌어지면 시간축이 끊긴 것으로 본다. */
        const val MAX_GAP_NS = 4_294_967_295L
    }
}

/** 가속도 m/s² → mg 정수, 자이로 rad/s → mrad/s 정수. */
private fun ImuSample.toInts(): IntArray =
    when (type) {
        ImuSample.Type.ACC -> intArrayOf(toMilliG(x), toMilliG(y), toMilliG(z))
        ImuSample.Type.GYRO -> intArrayOf(toMilliRad(x), toMilliRad(y), toMilliRad(z))
    }

private const val STANDARD_GRAVITY = 9.80665f

private fun toMilliG(value: Float): Int = Math.round(value / STANDARD_GRAVITY * 1000f)

private fun toMilliRad(value: Float): Int = Math.round(value * 1000f)
