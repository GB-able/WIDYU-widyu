package com.widucorp.widu.data.util

import androidx.health.services.client.data.HeartRateAccuracy
import androidx.health.services.client.data.HeartRateAccuracy.SensorStatus.Companion.ACCURACY_HIGH
import androidx.health.services.client.data.HeartRateAccuracy.SensorStatus.Companion.ACCURACY_LOW
import androidx.health.services.client.data.HeartRateAccuracy.SensorStatus.Companion.ACCURACY_MEDIUM
import androidx.health.services.client.data.HeartRateAccuracy.SensorStatus.Companion.NO_CONTACT
import androidx.health.services.client.data.HeartRateAccuracy.SensorStatus.Companion.UNRELIABLE
import androidx.health.services.client.data.SampleDataPoint
import com.widucorp.widu.data.model.HeartRateAccuracyLabel
import com.widucorp.widu.data.model.HeartRateReading
import kotlin.math.roundToInt

/** 화면 표시용 최신 값. 전송에는 쓰지 않는다 — 전송은 [toReading] 으로 모든 샘플을 보낸다. */
fun List<SampleDataPoint<Double>>.latestHeartRate(): Int? =
    this
        .asSequence()
        .filter { sample ->
            val accuracy = sample.accuracy as? HeartRateAccuracy
            accuracy == null || accuracy.sensorStatus == ACCURACY_HIGH || accuracy.sensorStatus == ACCURACY_MEDIUM
        }.maxByOrNull { sample -> sample.timeDurationFromBoot }
        ?.value
        ?.toInt()

fun SampleDataPoint<Double>.toReading(): HeartRateReading =
    HeartRateReading(
        bpm = value.takeIf { it.isFinite() }?.roundToInt() ?: 0,
        elapsedNs = timeDurationFromBoot.toNanos(),
        accuracy =
            when ((accuracy as? HeartRateAccuracy)?.sensorStatus) {
                ACCURACY_HIGH -> HeartRateAccuracyLabel.HIGH
                ACCURACY_MEDIUM -> HeartRateAccuracyLabel.MEDIUM
                ACCURACY_LOW -> HeartRateAccuracyLabel.LOW
                UNRELIABLE, NO_CONTACT -> HeartRateAccuracyLabel.UNRELIABLE
                else -> HeartRateAccuracyLabel.UNKNOWN
            },
    )
