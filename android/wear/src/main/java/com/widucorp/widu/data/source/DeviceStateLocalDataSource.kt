package com.widucorp.widu.data.source

import kotlinx.coroutines.flow.Flow

/** 연구 모드 상태 이벤트의 원천. 모든 Flow 는 구독 즉시 현재 값을 내고, 이후 바뀔 때마다 낸다. */
interface DeviceStateLocalDataSource {
    fun charging(): Flow<Boolean>

    fun powerSave(): Flow<Boolean>

    fun screenOn(): Flow<Boolean>

    /** `Settings.System.SCREEN_BRIGHTNESS`(0~255). 읽지 못하면 -1. */
    fun brightness(): Flow<Int>

    /** 착용 감지 센서 원래 값(1 착용, 0 미착용). 센서가 없는 기기는 null 하나만 낸다. */
    fun offBodyRaw(): Flow<Int?>

    fun phoneConnected(): Flow<Boolean>
}
