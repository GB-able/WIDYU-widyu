package com.gbable.widu.data.source

import com.gbable.widu.data.model.ImuConfig
import kotlinx.coroutines.flow.StateFlow

/** 폰이 Data Layer 로 넘겨 준 서버 수집 설정. 받은 적이 없으면 [ImuConfig] 기본값이다. */
interface ImuConfigLocalDataSource {
    fun config(): StateFlow<ImuConfig>

    fun apply(config: ImuConfig)
}
