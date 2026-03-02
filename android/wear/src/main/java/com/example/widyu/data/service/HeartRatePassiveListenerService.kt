package com.example.widyu.data.service

import androidx.health.services.client.PassiveListenerService
import androidx.health.services.client.data.DataPointContainer
import androidx.health.services.client.data.DataType
import com.example.widyu.data.repository.HeartRateRepository
import dagger.hilt.EntryPoint
import dagger.hilt.InstallIn
import dagger.hilt.android.EntryPointAccessors
import dagger.hilt.components.SingletonComponent

class HeartRatePassiveListenerService : PassiveListenerService() {
    private val entryPoint by lazy {
        EntryPointAccessors.fromApplication<ServiceEntryPoint>(applicationContext)
    }

    private val repository: HeartRateRepository by lazy { entryPoint.heartRateRepository() }

    override fun onNewDataPointsReceived(dataPoints: DataPointContainer) {
        val heartRateSamples = dataPoints.getData(DataType.HEART_RATE_BPM)
        heartRateSamples.lastOrNull()?.let { sample ->
            repository.sendHeartRate(sample.value.toInt())
        }
    }

    @EntryPoint
    @InstallIn(SingletonComponent::class)
    interface ServiceEntryPoint {
        fun heartRateRepository(): HeartRateRepository
    }
}
