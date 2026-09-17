package com.gbable.widu.data.source

import com.gbable.widu.data.model.MeasureResult
import kotlinx.coroutines.flow.Flow

interface HeartRateLocalDataSource {
    suspend fun hasHeartRateCapability(): Boolean

    fun getMeasureResult(): Flow<MeasureResult>

    suspend fun restartSession()
}
