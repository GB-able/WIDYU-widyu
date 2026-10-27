package com.widucorp.widu.data.source

import com.widucorp.widu.data.model.MeasureResult
import kotlinx.coroutines.flow.Flow

interface HeartRateLocalDataSource {
    suspend fun hasHeartRateCapability(): Boolean

    fun getMeasureResult(): Flow<MeasureResult>

    suspend fun restartSession()
}
