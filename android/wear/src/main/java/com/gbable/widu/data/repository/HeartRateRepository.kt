package com.gbable.widu.data.repository

import com.gbable.widu.data.model.HeartRateStatus
import com.gbable.widu.data.model.MeasureResult
import kotlinx.coroutines.flow.Flow

interface HeartRateRepository {
    suspend fun hasHeartRateCapability(): Result<Boolean>

    /** 구독하는 동안 측정하며, 센서가 준 샘플을 배치로 묶어 폰에 보낸다. */
    fun getHeartRate(): Flow<MeasureResult>

    fun getHeartRateStatus(): Flow<HeartRateStatus>

    suspend fun restartSession()
}
