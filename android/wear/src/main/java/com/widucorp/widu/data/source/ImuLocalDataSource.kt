package com.widucorp.widu.data.source

import com.widucorp.widu.data.model.ImuConfig
import com.widucorp.widu.data.model.ImuSample
import kotlinx.coroutines.flow.Flow

interface ImuLocalDataSource {
    /**
     * 수집 설정은 서버에서 내려오므로 등록 시점에 받는다.
     *
     * 센서는 배치 길이만큼 FIFO 에 모아 두므로, 수집이 취소되면 FIFO 를 비워 남은 샘플을 [onDrained] 로 넘긴 뒤 해제한다.
     * 취소된 흐름으로는 더 내보낼 수 없어 따로 넘긴다. 취소한 쪽의 종료 처리가 이것을 이어 붙인다.
     */
    fun samples(
        config: ImuConfig,
        onDrained: (List<ImuSample>) -> Unit,
    ): Flow<ImuSample>
}
