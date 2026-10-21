package com.widucorp.widu.data.repository

import com.widucorp.widu.data.model.ImuBatch
import kotlinx.coroutines.flow.Flow

interface ImuRepository {
    fun batches(): Flow<ImuBatch>
}
