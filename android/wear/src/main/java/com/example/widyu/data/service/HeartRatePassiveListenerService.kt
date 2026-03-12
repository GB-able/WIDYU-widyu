package com.example.widyu.data.service

import android.util.Log
import androidx.health.services.client.PassiveListenerService
import androidx.health.services.client.data.DataPointContainer
import androidx.health.services.client.data.DataType
import com.example.widyu.data.model.MeasureResult
import com.example.widyu.data.repository.HeartRateRepository
import com.example.widyu.data.util.latestHeartRate
import dagger.hilt.EntryPoint
import dagger.hilt.InstallIn
import dagger.hilt.android.EntryPointAccessors
import dagger.hilt.components.SingletonComponent

class HeartRatePassiveListenerService : PassiveListenerService() {
    private val repository: HeartRateRepository by lazy {
        EntryPointAccessors
            .fromApplication<ServiceEntryPoint>(applicationContext)
            .heartRateRepository()
    }

    override fun onNewDataPointsReceived(dataPoints: DataPointContainer) {
        Log.i(
            "Widyu",
            "PassiveListenerService Triggered: ${dataPoints.getData(DataType.HEART_RATE_BPM)}",
        )
        dataPoints.getData(DataType.HEART_RATE_BPM).latestHeartRate()?.let { heartRate ->
            Log.i("Widyu", "PassiveListenerService Heart Rate: $heartRate")
            runCatching { MeasureResult.HeartRate(heartRate) }
                .onSuccess { repository.sendHeartRate(heartRate) }
                .onFailure { Log.i("Widyu", "Heart Rate Error", it) }
        }
    }

    @EntryPoint
    @InstallIn(SingletonComponent::class)
    interface ServiceEntryPoint {
        fun heartRateRepository(): HeartRateRepository
    }
}
