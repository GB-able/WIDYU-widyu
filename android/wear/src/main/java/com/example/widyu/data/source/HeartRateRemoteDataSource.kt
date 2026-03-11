package com.example.widyu.data.source

import kotlinx.coroutines.flow.Flow

interface HeartRateRemoteDataSource {
    fun sendHeartRate(heartRate: Int)

    fun fetchHeartRateStatus(): Flow<String>
}
