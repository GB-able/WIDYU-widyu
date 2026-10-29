package com.widucorp.widu.medication_alarm

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val id = intent.getStringExtra("groupId") ?: return
        if (intent.action == "com.widucorp.widu.medication.STOP") {
            MedicationAlarmPlugin.stop(context, id)
            return
        }
        val group = AlarmScheduler(context).fired(id) ?: return
        try {
            ContextCompat.startForegroundService(
                context, Intent(context, AlarmPlaybackService::class.java)
                    .putExtra("groupId", group.getString("groupId"))
            )
        } catch (e: Exception) {
            synchronized(AlarmStore.lock) {
                val state = AlarmStore.read(context)
                state.put("playbackError", e.javaClass.simpleName)
                AlarmStore.write(context, state)
            }
        }
    }
}

class AlarmRestoreReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        // No service, network request or Flutter engine starts on boot.
        AlarmScheduler(context).reconcile(force = true)
    }
}
