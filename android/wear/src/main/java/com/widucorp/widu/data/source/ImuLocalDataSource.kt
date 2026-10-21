package com.widucorp.widu.data.source

import com.widucorp.widu.data.model.ImuConfig
import com.widucorp.widu.data.model.ImuSample
import kotlinx.coroutines.flow.Flow

interface ImuLocalDataSource {
    /** 수집 설정은 서버에서 내려오므로 등록 시점에 받는다. */
    fun samples(config: ImuConfig): Flow<ImuSample>

    /** 자이로 결측이 「센서 미지원」인지 구별하려면 Repository 가 이것을 알아야 한다. (A 1.2.6) */
    fun hasGyroscope(): Boolean
}
