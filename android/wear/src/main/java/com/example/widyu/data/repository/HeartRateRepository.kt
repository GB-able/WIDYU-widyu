package com.example.widyu.data.repository

import com.example.widyu.data.model.HeartRateStatus
import com.example.widyu.data.model.MeasureResult
import kotlinx.coroutines.flow.Flow

interface HeartRateRepository {
    suspend fun hasHeartRateCapability(): Result<Boolean>

    fun getHeartRate(): Flow<MeasureResult>

    fun sendHeartRate(heartRate: Int)

    fun getHeartRateStatus(): Flow<HeartRateStatus>

    suspend fun restartSession()
}
