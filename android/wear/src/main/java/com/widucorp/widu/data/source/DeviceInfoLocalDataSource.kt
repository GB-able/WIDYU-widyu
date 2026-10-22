package com.widucorp.widu.data.source

import java.io.BufferedWriter

/** 배치 봉투에 실을 기기 정보. Repository 가 Context 를 직접 만지지 않게 가둔다. */
interface DeviceInfoLocalDataSource {
    fun deviceId(): String

    fun batteryPercent(): Int?

    /** 기기-1 측정용 원시 로그. 릴리스에서는 열지 않으므로 null 이 돌아온다. */
    fun openRawLog(): BufferedWriter?
}
