package com.gbable.widu.data.repository

import com.gbable.widu.data.model.ImuBatch
import kotlinx.coroutines.flow.Flow

interface ImuRepository {
    fun batches(): Flow<ImuBatch>
}
