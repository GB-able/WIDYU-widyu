package com.gbable.widu.data.repository

import com.gbable.widu.data.model.HeartRateStatus
import com.gbable.widu.data.model.MeasureResult
import kotlinx.coroutines.flow.Flow

interface HeartRateRepository {
    suspend fun hasHeartRateCapability(): Result<Boolean>

    fun getHeartRate(): Flow<MeasureResult>

    fun sendHeartRate(heartRate: Int)

    fun getHeartRateStatus(): Flow<HeartRateStatus>

    suspend fun restartSession()
}
