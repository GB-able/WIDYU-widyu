package com.gbable.widu.data.source

import com.gbable.widu.data.model.ImuSample
import kotlinx.coroutines.flow.Flow

interface ImuLocalDataSource {
    fun samples(): Flow<ImuSample>

    /** 자이로 결측이 「센서 미지원」인지 구별하려면 Repository 가 이것을 알아야 한다. (A 1.2.6) */
    fun hasGyroscope(): Boolean
}
