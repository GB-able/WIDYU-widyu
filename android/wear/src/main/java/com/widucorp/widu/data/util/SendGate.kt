package com.widucorp.widu.data.util

import android.os.SystemClock
import kotlinx.coroutines.channels.BufferOverflow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import javax.inject.Inject
import javax.inject.Singleton

/**
 * 심박·가속도를 같은 순간에 내보내 블루투스가 전송 주기마다 한 번만 깨게 한다.
 *
 * 코루틴 delay 는 CPU 가 자는 동안 멈추므로 타이머를 두지 않는다. 대신 어느 쪽이든 데이터가 도착할 때
 * (센서가 CPU 를 깨운 순간) 경과 시간을 [SystemClock.elapsedRealtime] 으로 재고, 주기가 찼으면 둘 다에 신호를 보낸다.
 */
@Singleton
class SendGate @Inject constructor() {
    private val signal = MutableSharedFlow<Unit>(extraBufferCapacity = 1, onBufferOverflow = BufferOverflow.DROP_OLDEST)
    val ticks: SharedFlow<Unit> = signal

    private var lastTickMs = SystemClock.elapsedRealtime()

    /** 데이터가 도착할 때마다 부른다. 센서 묶음이 5초 근처로 흔들리므로 반 묶음만큼 일찍 연다. */
    @Synchronized
    fun onData() {
        val nowMs = SystemClock.elapsedRealtime()
        if (nowMs - lastTickMs < SEND_INTERVAL_MS - HALF_SENSOR_BATCH_MS) return
        lastTickMs = nowMs
        signal.tryEmit(Unit)
    }

    private companion object {
        const val SEND_INTERVAL_MS = 5_000L
        const val HALF_SENSOR_BATCH_MS = 2_500L
    }
}
