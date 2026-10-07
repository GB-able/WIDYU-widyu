package com.gbable.widu.data.repository

import android.util.Log
import com.gbable.widu.data.model.HeartRateStatus
import com.gbable.widu.data.model.MeasureResult
import com.gbable.widu.data.source.HeartRateLocalDataSource
import com.gbable.widu.data.source.HeartRateRemoteDataSource
import com.gbable.widu.data.util.OnBodyStateHolder
import com.gbable.widu.di.ApplicationScope
import com.gbable.widu.di.IoDispatcher
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.channelFlow
import kotlinx.coroutines.flow.shareIn
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.concurrent.atomic.AtomicReference
import javax.inject.Inject

class HeartRateRepositoryImpl @Inject constructor(
    private val heartRateLocalDataSource: HeartRateLocalDataSource,
    private val heartRateRemoteDataSource: HeartRateRemoteDataSource,
    private val onBodyStateHolder: OnBodyStateHolder,
    @IoDispatcher private val ioDispatcher: CoroutineDispatcher,
    @ApplicationScope applicationScope: CoroutineScope,
) : HeartRateRepository {
    private val heartRates: SharedFlow<MeasureResult> =
        channelFlow {
            val latestHeartRate = AtomicReference<Int?>(null)

            val senderJob =
                launch {
                    while (true) {
                        delay(HEART_RATE_SEND_INTERVAL_MS)
                        latestHeartRate.get()?.let { heartRate ->
                            try {
                                withContext(ioDispatcher) {
                                    heartRateRemoteDataSource.sendHeartRate(heartRate)
                                }
                            } catch (exception: CancellationException) {
                                throw exception
                            } catch (exception: Exception) {
                                Log.w(TAG, "Failed to send heart rate", exception)
                            }
                        }
                    }
                }

            try {
                heartRateLocalDataSource.getMeasureResult().collect { measureResult ->
                    when (measureResult) {
                        is MeasureResult.HeartRate -> latestHeartRate.set(measureResult.value)
                        MeasureResult.SessionSuperseded -> latestHeartRate.set(null)
                        // 착용 여부를 말해 주는 가용성 변화만 반영한다. 모르는 값으로 덮지 않는다.
                        is MeasureResult.Availability ->
                            measureResult.isOnBody?.let(onBodyStateHolder::update) ?: Unit
                    }
                    send(measureResult)
                }
            } finally {
                senderJob.cancel()
            }
        }.shareIn(
            scope = applicationScope,
            started = SharingStarted.Lazily,
            replay = 1,
        )

    override suspend fun hasHeartRateCapability(): Result<Boolean> = runCatching { heartRateLocalDataSource.hasHeartRateCapability() }

    override fun getHeartRate(): Flow<MeasureResult> = heartRates

    override fun sendHeartRate(heartRate: Int) = heartRateRemoteDataSource.sendHeartRate(heartRate)

    override fun getHeartRateStatus(): Flow<HeartRateStatus> = heartRateRemoteDataSource.fetchHeartRateStatus()

    override suspend fun restartSession() = heartRateLocalDataSource.restartSession()

    private companion object {
        const val HEART_RATE_SEND_INTERVAL_MS = 1_000L
        const val TAG = "Widyu"
    }
}
