package com.widucorp.widu.data.service

import com.widucorp.widu.data.model.ImuConfig
import com.widucorp.widu.data.source.ImuConfigLocalDataSource
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMap
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.WearableListenerService
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

/** 폰이 넘겨 주는 수집 설정 수신부. 경로가 하나뿐이라 덮어써지며 항상 최신 값만 남는다. */
@AndroidEntryPoint
class ImuConfigListenerService : WearableListenerService() {
    @Inject
    lateinit var imuConfigLocalDataSource: ImuConfigLocalDataSource

    override fun onDataChanged(events: DataEventBuffer) {
        events
            .filter { it.type == DataEvent.TYPE_CHANGED && it.dataItem.uri.path == PATH }
            .forEach { imuConfigLocalDataSource.apply(DataMapItem.fromDataItem(it.dataItem).dataMap.toImuConfig()) }
    }

    private companion object {
        const val PATH = "/imu/config"
    }
}

/** 폰과 공유하는 키 계약. 빠진 키는 현재 기본값을 유지한다. */
private fun DataMap.toImuConfig(): ImuConfig {
    val default = ImuConfig()
    return default.copy(
        collectionMode = getString("collection_mode") ?: default.collectionMode,
        gyroMode = getString("gyro_mode") ?: default.gyroMode,
        accHz = getInt("acc_hz", default.accHz),
        batchSec = getInt("batch_sec", default.batchSec),
        impactG = getFloat("impact_g", default.impactG),
        backfillPreSec = getInt("backfill_pre_sec", default.backfillPreSec),
        backfillPostSec = getInt("backfill_post_sec", default.backfillPostSec),
    )
}
