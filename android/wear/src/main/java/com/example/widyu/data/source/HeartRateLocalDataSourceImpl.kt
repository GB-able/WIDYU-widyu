package com.example.widyu.data.source

import android.util.Log
import androidx.concurrent.futures.await
import androidx.health.services.client.HealthServicesClient
import androidx.health.services.client.MeasureCallback
import androidx.health.services.client.data.Availability
import androidx.health.services.client.data.DataPointContainer
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.DataTypeAvailability
import androidx.health.services.client.data.DeltaDataType
import androidx.health.services.client.data.PassiveListenerConfig
import com.example.widyu.data.model.MeasureResult
import com.example.widyu.data.service.HeartRatePassiveListenerService
import com.example.widyu.data.util.latestHeartRate
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.runBlocking
import javax.inject.Inject

class HeartRateLocalDataSourceImpl @Inject constructor(
    healthClient: HealthServicesClient,
) : HeartRateLocalDataSource {
    private val measureClient = healthClient.measureClient
    private val passiveMonitoringClient = healthClient.passiveMonitoringClient
    private var measureCallback: MeasureCallback? = null

    override suspend fun hasHeartRateCapability(): Boolean {
        val capabilities = measureClient.getCapabilitiesAsync().await()
        return (DataType.HEART_RATE_BPM in capabilities.supportedDataTypesMeasure)
    }

    override fun getMeasureResult(): Flow<MeasureResult> =
        callbackFlow {
            measureCallback =
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
                        data.getData(DataType.HEART_RATE_BPM).latestHeartRate()?.let { heartRate ->
                            runCatching { MeasureResult.HeartRate(heartRate) }
                                .onSuccess { trySendBlocking(it) }
                                .onFailure { Log.i("Widyu", "Heart Rate Error", it) }
                        }
                    }
                }

            measureClient.registerMeasureCallback(DataType.HEART_RATE_BPM, measureCallback!!)

            awaitClose { runBlocking { stopMeasure() } }
        }

    override suspend fun startPassiveMonitoring() {
        val config =
            PassiveListenerConfig
                .builder()
                .setDataTypes(setOf(DataType.HEART_RATE_BPM))
                .build()
        passiveMonitoringClient
            .setPassiveListenerServiceAsync(
                HeartRatePassiveListenerService::class.java,
                config,
            ).await()
    }

    override suspend fun stopPassiveMonitoring() {
        passiveMonitoringClient.clearPassiveListenerServiceAsync().await()
    }

    private suspend fun stopMeasure() {
        measureCallback?.let { callback ->
            measureClient.unregisterMeasureCallbackAsync(DataType.HEART_RATE_BPM, callback).await()
            measureCallback = null
        }
    }
}
