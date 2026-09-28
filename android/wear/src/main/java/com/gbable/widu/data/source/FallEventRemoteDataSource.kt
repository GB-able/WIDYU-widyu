package com.gbable.widu.data.source

interface FallEventRemoteDataSource {
    fun sendFallEvent(eventTimeEpochMs: Long)
}
