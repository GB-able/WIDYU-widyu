package com.example.widyu.data.service

import androidx.health.services.client.PassiveListenerService
import androidx.health.services.client.data.DataPointContainer
import androidx.health.services.client.data.DataType
import com.example.widyu.data.repository.HeartRateRepository
import dagger.hilt.EntryPoint
import dagger.hilt.InstallIn
import dagger.hilt.android.EntryPointAccessors
import dagger.hilt.components.SingletonComponent
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch

class HeartRatePassiveListenerService : PassiveListenerService() {
    private val entryPoint by lazy {
        EntryPointAccessors.fromApplication<ServiceEntryPoint>(applicationContext)
    }

    private val serviceScope: CoroutineScope by lazy {
        CoroutineScope(SupervisorJob() + entryPoint.ioDispatcher())
    }

    private val repository: HeartRateRepository by lazy { entryPoint.heartRateRepository() }

    override fun onNewDataPointsReceived(dataPoints: DataPointContainer) {
        val heartRateSamples = dataPoints.getData(DataType.HEART_RATE_BPM)
        heartRateSamples.lastOrNull()?.let { sample ->
            serviceScope.launch {
                repository.sendHeartRate(sample.value)
            }
        }
    }

    @EntryPoint
    @InstallIn(SingletonComponent::class)
    interface ServiceEntryPoint {
        fun heartRateRepository(): HeartRateRepository

        fun ioDispatcher(): CoroutineDispatcher
    }
}
