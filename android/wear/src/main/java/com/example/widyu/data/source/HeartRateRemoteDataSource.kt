package com.example.widyu.data.source

interface HeartRateRemoteDataSource {
    suspend fun sendHeartRate(heartRate: Int)
}
