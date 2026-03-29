package com.example.widyu.data.source

import com.example.widyu.data.model.HeartRateStatus
import kotlinx.coroutines.flow.Flow

interface HeartRateRemoteDataSource {
    fun sendHeartRate(heartRate: Int)

    fun fetchHeartRateStatus(): Flow<HeartRateStatus>
}
