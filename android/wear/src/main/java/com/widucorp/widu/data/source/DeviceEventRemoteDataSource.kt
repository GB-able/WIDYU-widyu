package com.widucorp.widu.data.source

import com.widucorp.widu.data.model.DeviceEvent

/** 이벤트마다 `/device_event/<event_id>` DataItem 을 둔다. 폰이 서버 결과를 받은 뒤 지운다. */
interface DeviceEventRemoteDataSource {
    suspend fun send(event: DeviceEvent)
}
