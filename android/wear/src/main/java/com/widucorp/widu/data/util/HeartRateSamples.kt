package com.widucorp.widu.data.util

import com.widucorp.widu.data.model.ClockInfo
import com.widucorp.widu.data.model.HeartRateAccuracyLabel
import com.widucorp.widu.data.model.HeartRateReading
import com.widucorp.widu.data.model.HeartRateSample

private const val NANOS_PER_MILLI = 1_000_000L
private const val MAX_SAMPLES_PER_BATCH = 60
private val VALID_BPM = 1..300

/**
 * 센서가 준 샘플을 서버 심박 배치 규칙(1~60개, ts_ms 엄격 증가, bpm 0~300, bpm 0 은 UNRELIABLE)에 맞춰 묶는다.
 * 값은 거르지 않는다(A 1.2.1). 서버가 거절하는 경우만 고친다 — 범위 밖 bpm 은 0/UNRELIABLE,
 * 같은 ms 로 겹치는 샘플은 엄격 증가를 지키려고 나중 것만 남긴다.
 * 시각은 앵커로 환산한 잰 시각이다(A 1.1.1). Health Services 경과 시각이 SensorEvent 와 같은 시계인지는 실기기 확인 대기(코드-10).
 */
fun List<HeartRateReading>.toBatchSamples(clock: ClockInfo): List<List<HeartRateSample>> =
    sortedBy { it.elapsedNs }
        .map { reading ->
            val valid = reading.bpm in VALID_BPM
            HeartRateSample(
                bpm = if (valid) reading.bpm else 0,
                tsMs = clock.anchorEpochMs + Math.floorDiv(reading.elapsedNs - clock.anchorElapsedNs, NANOS_PER_MILLI),
                accuracy = if (valid) reading.accuracy else HeartRateAccuracyLabel.UNRELIABLE,
            )
        }.asReversed()
        .distinctBy { it.tsMs }
        .asReversed()
        .chunked(MAX_SAMPLES_PER_BATCH)
