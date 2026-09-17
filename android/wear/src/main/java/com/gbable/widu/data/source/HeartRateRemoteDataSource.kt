package com.gbable.widu.data.source

import com.gbable.widu.data.model.HeartRateStatus
import kotlinx.coroutines.flow.Flow

interface HeartRateRemoteDataSource {
    fun sendHeartRate(heartRate: Int)

    fun fetchHeartRateStatus(): Flow<HeartRateStatus>
}
