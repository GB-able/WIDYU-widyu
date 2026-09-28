package com.gbable.widu.data.source

import android.util.Log
import androidx.concurrent.futures.await
import androidx.health.services.client.HealthServicesClient
import androidx.health.services.client.data.HealthEvent
import androidx.health.services.client.data.PassiveListenerConfig
import com.gbable.widu.data.service.FallListenerService
import javax.inject.Inject

class FallDetectionLocalDataSourceImpl @Inject constructor(
    healthClient: HealthServicesClient,
) : FallDetectionLocalDataSource {
    private val passiveMonitoringClient = healthClient.passiveMonitoringClient

    override suspend fun hasFallDetectionCapability(): Boolean {
        val capabilities = passiveMonitoringClient.getCapabilitiesAsync().await()
        return HealthEvent.Type.FALL_DETECTED in capabilities.supportedHealthEventTypes
    }

    override suspend fun registerFallListener() {
        runCatching {
            val config =
                PassiveListenerConfig
                    .builder()
                    .setHealthEventTypes(setOf(HealthEvent.Type.FALL_DETECTED))
                    .build()
            passiveMonitoringClient.setPassiveListenerServiceAsync(FallListenerService::class.java, config).await()
        }.onFailure { Log.e("Widyu", "Failed to register fall listener", it) }
    }

    override suspend fun unregisterFallListener() {
        runCatching {
            passiveMonitoringClient.clearPassiveListenerServiceAsync().await()
        }.onFailure { Log.e("Widyu", "Failed to unregister fall listener", it) }
    }
}
