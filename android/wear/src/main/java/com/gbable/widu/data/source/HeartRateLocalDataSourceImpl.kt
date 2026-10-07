package com.gbable.widu.data.source

import android.util.Log
import androidx.concurrent.futures.await
import androidx.health.services.client.ExerciseUpdateCallback
import androidx.health.services.client.HealthServicesClient
import androidx.health.services.client.data.Availability
import androidx.health.services.client.data.BatchingMode
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.DataTypeAvailability
import androidx.health.services.client.data.ExerciseConfig
import androidx.health.services.client.data.ExerciseEndReason.Companion.AUTO_END_SUPERSEDED
import androidx.health.services.client.data.ExerciseLapSummary
import androidx.health.services.client.data.ExerciseType
import androidx.health.services.client.data.ExerciseUpdate
import com.gbable.widu.data.model.MeasureResult
import com.gbable.widu.data.util.latestHeartRate
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.runBlocking
import javax.inject.Inject

class HeartRateLocalDataSourceImpl @Inject constructor(
    healthClient: HealthServicesClient,
) : HeartRateLocalDataSource {
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
                            trySendBlocking(
                                MeasureResult.Availability(
                                    isAvailable = availability == DataTypeAvailability.AVAILABLE,
                                    // 그 외 사유(초기화 중·신호 불량)는 착용 여부를 말해 주지 않는다.
                                    isOnBody =
                                        when (availability) {
                                            DataTypeAvailability.AVAILABLE -> true
                                            DataTypeAvailability.UNAVAILABLE_DEVICE_OFF_BODY -> false
                                            else -> null
                                        },
                                ),
                            )
                        }
                    }

                    override fun onExerciseUpdateReceived(update: ExerciseUpdate) {
                        if (update.exerciseStateInfo.endReason == AUTO_END_SUPERSEDED) {
                            trySendBlocking(MeasureResult.SessionSuperseded)
                            return
                        }
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

    override suspend fun restartSession() {
        stopExerciseSession()
        startExerciseSession()
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
}
