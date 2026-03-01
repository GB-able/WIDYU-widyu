package com.example.widyu.data.repository

import com.example.widyu.data.model.MeasureResult
import com.example.widyu.data.source.HeartRateLocalDataSource
import com.example.widyu.data.source.HeartRateRemoteDataSource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject

class HeartRateRepositoryImpl @Inject constructor(
    private val localDataSource: HeartRateLocalDataSource,
    private val remoteDataSource: HeartRateRemoteDataSource,
) : HeartRateRepository {
    override suspend fun hasHeartRateCapability(): Result<Boolean> = runCatching { localDataSource.hasHeartRateCapability() }

    override fun getHeartRate(): Flow<MeasureResult> =
        localDataSource.getMeasureResult().onEach { measureResult ->
            if (measureResult is MeasureResult.HeartRate) {
                remoteDataSource.sendHeartRate(measureResult.value)
            }
        }

    override fun startPassiveMonitoring() = runCatching { localDataSource.startPassiveMonitoring() }

    override fun stopPassiveMonitoring() = runCatching { localDataSource.stopPassiveMonitoring() }

    override suspend fun sendHeartRate(heartRate: Int) = runCatching { remoteDataSource.sendHeartRate(heartRate) }
}
