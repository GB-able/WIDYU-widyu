package com.example.widyu.data.source

import kotlinx.coroutines.flow.Flow

interface HeartRateStatusRemoteDataSource {
    fun getHeartRateStatus(): Flow<String>
}
