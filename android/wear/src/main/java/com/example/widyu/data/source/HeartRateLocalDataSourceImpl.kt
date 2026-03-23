package com.example.widyu.data.source

import android.util.Log
import androidx.concurrent.futures.await
import androidx.health.services.client.ExerciseUpdateCallback
import androidx.health.services.client.HealthServicesClient
import androidx.health.services.client.data.Availability
import androidx.health.services.client.data.BatchingMode
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.DataTypeAvailability
import androidx.health.services.client.data.ExerciseConfig
import androidx.health.services.client.data.ExerciseLapSummary
import androidx.health.services.client.data.ExerciseType
import androidx.health.services.client.data.ExerciseUpdate
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
    private val passiveMonitoringClient = healthClient.passiveMonitoringClient
    private val exerciseClient = healthClient.exerciseClient

    override suspend fun hasHeartRateCapability(): Boolean {
        val capabilities = exerciseClient.getCapabilitiesAsync().await()
        if (ExerciseType.WALKING in capabilities.supportedExerciseTypes) {
            val walkingCapabilities = capabilities.getExerciseTypeCapabilities(ExerciseType.WALKING)
            return (
                DataType.HEART_RATE_BPM in walkingCapabilities.supportedDataTypes &&
                    BatchingMode.HEART_RATE_5_SECONDS in capabilities.supportedBatchingModeOverrides
            )
        }
        return false
    }

    override fun getMeasureResult(): Flow<MeasureResult> =
        callbackFlow {
            val callback =
                object : ExerciseUpdateCallback {
                    override fun onAvailabilityChanged(
                        dataType: DataType<*, *>,
                        availability: Availability,
                    ) {
                        if (dataType == DataType.HEART_RATE_BPM && availability is DataTypeAvailability) {
                            trySendBlocking(MeasureResult.Availability(availability == DataTypeAvailability.AVAILABLE))
                        }
                    }

                    override fun onExerciseUpdateReceived(update: ExerciseUpdate) {
                        val heartRateData = update.latestMetrics.getData(DataType.HEART_RATE_BPM)
                        heartRateData.latestHeartRate()?.let { heartRate ->
                            trySendBlocking(MeasureResult.HeartRate(heartRate))
                        }
                    }

                    override fun onRegistered() {}

                    override fun onRegistrationFailed(throwable: Throwable) {}

                    override fun onLapSummaryReceived(lapSummary: ExerciseLapSummary) {}
                }

            exerciseClient.setUpdateCallback(callback)
            startExerciseSession()

            awaitClose {
                runBlocking {
                    stopExerciseSession()
                    exerciseClient.clearUpdateCallbackAsync(callback)
                }
            }
        }

    private suspend fun startExerciseSession() {
        runCatching {
            val config =
                ExerciseConfig
                    .builder(ExerciseType.WALKING)
                    .setDataTypes(setOf(DataType.HEART_RATE_BPM))
                    .setBatchingModeOverrides(setOf(BatchingMode.HEART_RATE_5_SECONDS))
                    .setIsAutoPauseAndResumeEnabled(false)
                    .build()
            exerciseClient.startExerciseAsync(config).await()
        }.onFailure { Log.e("Widyu", "Failed to start exercise session", it) }
    }

    private suspend fun stopExerciseSession() {
        runCatching {
            exerciseClient.endExerciseAsync().await()
        }.onFailure { Log.e("Widyu", "Failed to stop exercise session", it) }
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
}
