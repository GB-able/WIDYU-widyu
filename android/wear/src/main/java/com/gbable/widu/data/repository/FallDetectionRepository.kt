package com.gbable.widu.data.repository

interface FallDetectionRepository {
    suspend fun startDetection(): Boolean

    suspend fun stopDetection()

    fun sendFallEvent(eventTimeEpochMs: Long)
}
