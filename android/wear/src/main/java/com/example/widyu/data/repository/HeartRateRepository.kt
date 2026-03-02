package com.example.widyu.data.repository

import com.example.widyu.data.model.MeasureResult
import kotlinx.coroutines.flow.Flow

interface HeartRateRepository {
    suspend fun hasHeartRateCapability(): Result<Boolean>

    fun getHeartRate(): Flow<MeasureResult>

    fun startPassiveMonitoring(): Result<Unit>

    fun stopPassiveMonitoring(): Result<Unit>

    fun sendHeartRate(heartRate: Int)
}
