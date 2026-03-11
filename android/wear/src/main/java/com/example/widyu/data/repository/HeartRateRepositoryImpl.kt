package com.example.widyu.data.repository

import com.example.widyu.data.model.MeasureResult
import com.example.widyu.data.source.HeartRateLocalDataSource
import com.example.widyu.data.source.HeartRateRemoteDataSource
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.onEach
import javax.inject.Inject

class HeartRateRepositoryImpl @Inject constructor(
    private val heartRateLocalDataSource: HeartRateLocalDataSource,
    private val heartRateRemoteDataSource: HeartRateRemoteDataSource,
) : HeartRateRepository {
    override suspend fun hasHeartRateCapability(): Result<Boolean> = runCatching { heartRateLocalDataSource.hasHeartRateCapability() }

    override fun getHeartRate(): Flow<MeasureResult> =
        heartRateLocalDataSource.getMeasureResult().onEach { measureResult ->
            if (measureResult is MeasureResult.HeartRate) {
                heartRateRemoteDataSource.sendHeartRate(measureResult.value)
            }
        }

    override suspend fun startPassiveMonitoring() = runCatching { heartRateLocalDataSource.startPassiveMonitoring() }

    override suspend fun stopPassiveMonitoring() = runCatching { heartRateLocalDataSource.stopPassiveMonitoring() }

    override fun sendHeartRate(heartRate: Int) = heartRateRemoteDataSource.sendHeartRate(heartRate)

    override fun getHeartRateStatus(): Flow<String> = heartRateRemoteDataSource.fetchHeartRateStatus()
}
