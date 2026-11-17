package com.widucorp.widu.data.repository

import com.widucorp.widu.data.model.DeviceEvent
import kotlinx.coroutines.flow.Flow

interface DeviceEventRepository {
    /** 연구 모드일 때만 상태 변화를 이벤트로 만들어 폰에 넘기고, 넘긴 이벤트를 흘린다. */
    fun events(): Flow<DeviceEvent>
}
