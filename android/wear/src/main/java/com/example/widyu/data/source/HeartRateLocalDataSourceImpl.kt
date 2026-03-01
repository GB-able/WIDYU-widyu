package com.example.widyu.data.source

import androidx.health.services.client.HealthServicesClient
import androidx.health.services.client.MeasureCallback
import androidx.health.services.client.data.Availability
import androidx.health.services.client.data.DataPointContainer
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.DataTypeAvailability
import androidx.health.services.client.data.DeltaDataType
import androidx.health.services.client.data.PassiveListenerConfig
import androidx.health.services.client.unregisterMeasureCallback
import com.example.widyu.data.model.MeasureResult
import com.example.widyu.data.service.HeartRatePassiveListenerService
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.guava.await
import kotlinx.coroutines.runBlocking
import javax.inject.Inject

class HeartRateLocalDataSourceImpl @Inject constructor(
    healthClient: HealthServicesClient,
) : HeartRateLocalDataSource {
    private val measureClient = healthClient.measureClient
    private val passiveMonitoringClient = healthClient.passiveMonitoringClient

    override suspend fun hasHeartRateCapability(): Boolean {
        val capabilities = measureClient.getCapabilitiesAsync().await()
        return (DataType.HEART_RATE_BPM in capabilities.supportedDataTypesMeasure)
    }

    override fun getMeasureResult(): Flow<MeasureResult> =
        callbackFlow {
            val callback =
                object : MeasureCallback {
                    override fun onAvailabilityChanged(
                        dataType: DeltaDataType<*, *>,
                        availability: Availability,
                    ) {
                        if (availability is DataTypeAvailability) {
                            val isAvailable = (availability == DataTypeAvailability.AVAILABLE)
                            trySendBlocking(MeasureResult.Availability(isAvailable))
                        }
                    }

                    override fun onDataReceived(data: DataPointContainer) {
                        data.getData(DataType.HEART_RATE_BPM).lastOrNull()?.let { sample ->
                            trySendBlocking(MeasureResult.HeartRate(sample.value.toInt()))
                        }
                    }
                }

            measureClient.registerMeasureCallback(DataType.HEART_RATE_BPM, callback)

            awaitClose {
                runBlocking {
                    measureClient.unregisterMeasureCallback(DataType.HEART_RATE_BPM, callback)
                }
            }
        }

    override fun startPassiveMonitoring() {
        val config =
            PassiveListenerConfig
                .builder()
                .setDataTypes(setOf(DataType.HEART_RATE_BPM))
                .build()
        passiveMonitoringClient.setPassiveListenerServiceAsync(
            HeartRatePassiveListenerService::class.java,
            config,
        )
    }

    override fun stopPassiveMonitoring() {
        passiveMonitoringClient.clearPassiveListenerServiceAsync()
    }
}
