package com.gbable.widu.data.service

import android.util.Log
import androidx.health.services.client.PassiveListenerService
import androidx.health.services.client.data.HealthEvent
import com.gbable.widu.data.repository.FallDetectionRepository
import dagger.hilt.android.AndroidEntryPoint
import javax.inject.Inject

@AndroidEntryPoint
class FallListenerService : PassiveListenerService() {
    @Inject
    lateinit var repository: FallDetectionRepository

    override fun onHealthEventReceived(event: HealthEvent) {
        if (event.type != HealthEvent.Type.FALL_DETECTED) return

        Log.d("Widyu", "Fall detected at ${event.eventTime}")
        repository.sendFallEvent(event.eventTime.toEpochMilli())
    }
}
