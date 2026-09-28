package com.gbable.widu.data.repository

import android.util.Log
import com.gbable.widu.data.source.FallDetectionLocalDataSource
import com.gbable.widu.data.source.FallEventRemoteDataSource
import javax.inject.Inject

class FallDetectionRepositoryImpl @Inject constructor(
    private val fallDetectionLocalDataSource: FallDetectionLocalDataSource,
    private val fallEventRemoteDataSource: FallEventRemoteDataSource,
) : FallDetectionRepository {
    override suspend fun startDetection(): Boolean {
        val isSupported =
            runCatching { fallDetectionLocalDataSource.hasFallDetectionCapability() }
                .onFailure { Log.e(TAG, "Failed to query fall detection capability", it) }
                .getOrDefault(false)
        if (!isSupported) {
            Log.w(TAG, "Fall detection is not supported on this device")
            return false
        }
        fallDetectionLocalDataSource.registerFallListener()
        return true
    }

    override suspend fun stopDetection() = fallDetectionLocalDataSource.unregisterFallListener()

    override fun sendFallEvent(eventTimeEpochMs: Long) = fallEventRemoteDataSource.sendFallEvent(eventTimeEpochMs)

    private companion object {
        const val TAG = "Widyu"
    }
}
