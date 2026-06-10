package com.example.widyu.data.source

import com.example.widyu.data.model.MeasureResult
import kotlinx.coroutines.flow.Flow

interface HeartRateLocalDataSource {
    suspend fun hasHeartRateCapability(): Boolean

    fun getMeasureResult(): Flow<MeasureResult>

    suspend fun restartSession()
}
