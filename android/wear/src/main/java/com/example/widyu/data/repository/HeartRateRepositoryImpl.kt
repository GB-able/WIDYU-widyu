package com.example.widyu.data.repository

import com.example.widyu.data.model.MeasureResult
import com.example.widyu.data.source.HeartRateLocalDataSource
import com.example.widyu.data.source.HeartRateRemoteDataSource
import com.example.widyu.di.ApplicationScope
import com.example.widyu.di.IoDispatcher
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.sample
import kotlinx.coroutines.flow.shareIn
import kotlinx.coroutines.withContext
import javax.inject.Inject

class HeartRateRepositoryImpl @Inject constructor(
    private val heartRateLocalDataSource: HeartRateLocalDataSource,
    private val heartRateRemoteDataSource: HeartRateRemoteDataSource,
    @IoDispatcher private val ioDispatcher: CoroutineDispatcher,
    @ApplicationScope applicationScope: CoroutineScope,
) : HeartRateRepository {
    @OptIn(FlowPreview::class)
    private val heartRates: SharedFlow<MeasureResult> =
        heartRateLocalDataSource
            .getMeasureResult()
            .sample(1000)
            .onEach { measureResult ->
                if (measureResult is MeasureResult.HeartRate) {
                    withContext(ioDispatcher) {
                        heartRateRemoteDataSource.sendHeartRate(measureResult.value)
                    }
                }
            }.shareIn(
                scope = applicationScope,
                started = SharingStarted.WhileSubscribed(5000),
                replay = 1,
            )

    override suspend fun hasHeartRateCapability(): Result<Boolean> = runCatching { heartRateLocalDataSource.hasHeartRateCapability() }

    override fun getHeartRate(): Flow<MeasureResult> = heartRates

    override fun sendHeartRate(heartRate: Int) = heartRateRemoteDataSource.sendHeartRate(heartRate)

    override fun getHeartRateStatus(): Flow<String> = heartRateRemoteDataSource.fetchHeartRateStatus()
}
