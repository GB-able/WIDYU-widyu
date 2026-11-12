package com.widucorp.widu.data.source

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
import androidx.health.services.client.data.ExerciseTrackedStatus.Companion.OWNED_EXERCISE_IN_PROGRESS
import androidx.health.services.client.data.ExerciseType
import androidx.health.services.client.data.ExerciseUpdate
import com.widucorp.widu.data.model.MeasureResult
import com.widucorp.widu.data.util.latestHeartRate
import com.widucorp.widu.data.util.toReading
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.channels.trySendBlocking
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
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
                            // 프로세스가 죽었다 살아나 세션을 새로 열면, 남아 있던 우리 세션도 SUPERSEDED 로 끝난다.
                            // 그 뒤에도 우리가 세션을 갖고 있으면 다른 앱에 뺏긴 것이 아니므로 알리지 않는다.
                            // 따로 돌리면 뒤이은 심박보다 늦게 도착해 복구된 화면을 다시 끊김으로 바꾸므로 이 스레드에서 기다린다.
                            if (!ownsExercise()) trySendBlocking(MeasureResult.SessionSuperseded)
                            return
                        }
                        val heartRateData = update.latestMetrics.getData(DataType.HEART_RATE_BPM)
                        if (heartRateData.isEmpty()) return
                        trySendBlocking(MeasureResult.HeartRate(heartRateData.latestHeartRate(), heartRateData.map { it.toReading() }))
                    }

                    override fun onRegistered() {}

                    override fun onRegistrationFailed(throwable: Throwable) {}

                    override fun onLapSummaryReceived(lapSummary: ExerciseLapSummary) {}
                }

            // 기본값(메인 스레드)으로 받으면 대기열이 찼을 때 trySendBlocking 이 메인 스레드를 붙잡는다.
            // 배치 전송 완료 알림도 메인 스레드에서 받으므로 서로를 기다리며 교착될 수 있다(ANR). 순서를 지키려고 스레드 하나만 쓴다.
            // 세션은 이미 우리 것이 돌고 있어도 새로 연다. 시작에 성공해야 이 클라이언트가 가용성(착용) 이벤트를 넘겨준다.
            val callbackExecutor = Executors.newSingleThreadExecutor()
            exerciseClient.setUpdateCallback(callbackExecutor, callback)
            startExerciseSession()

            // 화면이 꺼진 채 다시 차면 Health Services 가 5초 묶음 설정을 놓치고, 화면이 켜질 때까지 심박을 쥐고 있는다(SM-R860 실측, 최대 6분 30초).
            // 묶음 주기마다 밀어내 대부분 그 안에 넘어오게 한다. 세션이 없을 때의 실패는 다음 주기에 다시 시도하면 되므로 넘긴다.
            launch {
                while (true) {
                    delay(FLUSH_INTERVAL_MS)
                    runCatching { exerciseClient.flushAsync().await() }
                        .onFailure { Log.d("Widyu", "Failed to flush exercise data", it) }
                }
            }

            awaitClose {
                runBlocking {
                    stopExerciseSession()
                    // 해제가 끝나기 전에 실행기를 닫으면 늦게 온 콜백이 거절된다.
                    runCatching { exerciseClient.clearUpdateCallbackAsync(callback).await() }
                        .onFailure { Log.w("Widyu", "Failed to clear exercise callback", it) }
                }
                callbackExecutor.shutdown()
            }
        }

    override suspend fun restartSession() {
        stopExerciseSession()
        startExerciseSession()
    }

    /** 콜백 스레드에서 막고 기다린다. 조회에 실패하거나 늦으면 false — 알림을 띄우는 쪽(기존 동작)으로 둔다. */
    private fun ownsExercise(): Boolean =
        runCatching {
            exerciseClient
                .getCurrentExerciseInfoAsync()
                .get(OWNERSHIP_TIMEOUT_MS, TimeUnit.MILLISECONDS)
                .exerciseTrackedStatus == OWNED_EXERCISE_IN_PROGRESS
        }.onFailure { Log.w("Widyu", "Failed to read current exercise", it) }
            .getOrDefault(false)

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

    private companion object {
        /** [BatchingMode.HEART_RATE_5_SECONDS] 와 같은 주기. */
        const val FLUSH_INTERVAL_MS = 5_000L
        const val OWNERSHIP_TIMEOUT_MS = 2_000L
    }
}
