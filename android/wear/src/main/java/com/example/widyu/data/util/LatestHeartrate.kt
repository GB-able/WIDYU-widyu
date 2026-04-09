package com.example.widyu.data.util

import androidx.health.services.client.data.HeartRateAccuracy
import androidx.health.services.client.data.HeartRateAccuracy.SensorStatus.Companion.ACCURACY_HIGH
import androidx.health.services.client.data.HeartRateAccuracy.SensorStatus.Companion.ACCURACY_MEDIUM
import androidx.health.services.client.data.SampleDataPoint

fun List<SampleDataPoint<Double>>.latestHeartRate(): Int? =
    this
        .asSequence()
        .filter { sample ->
            val accuracy = sample.accuracy as? HeartRateAccuracy
            accuracy == null || accuracy.sensorStatus == ACCURACY_HIGH || accuracy.sensorStatus == ACCURACY_MEDIUM
        }.maxByOrNull { sample -> sample.timeDurationFromBoot }
        ?.value
        ?.toInt()
