package com.gbable.widu.data.source

interface FallDetectionLocalDataSource {
    suspend fun hasFallDetectionCapability(): Boolean

    suspend fun registerFallListener()

    suspend fun unregisterFallListener()
}
