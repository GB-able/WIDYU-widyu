package com.gbable.widu.data.repository

import com.gbable.widu.data.model.HeartRateStatus
import com.gbable.widu.data.model.MeasureResult
import com.gbable.widu.data.source.HeartRateLocalDataSource
import com.gbable.widu.data.source.HeartRateRemoteDataSource
import com.gbable.widu.di.ApplicationScope
import com.gbable.widu.di.IoDispatcher
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.shareIn
import kotlinx.coroutines.withContext
import javax.inject.Inject

class HeartRateRepositoryImpl @Inject constructor(
    private val heartRateLocalDataSource: HeartRateLocalDataSource,
    private val heartRateRemoteDataSource: HeartRateRemoteDataSource,
    @IoDispatcher private val ioDispatcher: CoroutineDispatcher,
    @ApplicationScope applicationScope: CoroutineScope,
) : HeartRateRepository {
    private val heartRates: SharedFlow<MeasureResult> =
        heartRateLocalDataSource
            .getMeasureResult()
            .onEach { measureResult ->
                if (measureResult is MeasureResult.HeartRate) {
                    withContext(ioDispatcher) {
                        heartRateRemoteDataSource.sendHeartRate(measureResult.value)
                    }
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
}
