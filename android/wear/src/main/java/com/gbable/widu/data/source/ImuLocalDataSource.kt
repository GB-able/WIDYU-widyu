package com.gbable.widu.data.source

import com.gbable.widu.data.model.ImuSample
import kotlinx.coroutines.flow.Flow

interface ImuLocalDataSource {
    fun samples(): Flow<ImuSample>
}
