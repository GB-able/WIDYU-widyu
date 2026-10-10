package com.gbable.widu.data.source

import android.content.Context
import android.os.SystemClock
import android.provider.Settings
import com.gbable.widu.data.model.ClockAnchor
import dagger.hilt.android.qualifiers.ApplicationContext
import java.util.UUID
import javax.inject.Inject

class ClockLocalDataSourceImpl @Inject constructor(
    @ApplicationContext private val context: Context,
) : ClockLocalDataSource {
    private val preferences = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)

    override fun bootId(): String {
        val bootCount = Settings.Global.getInt(context.contentResolver, Settings.Global.BOOT_COUNT, -1)
        val stored = preferences.getString(KEY_BOOT_ID, null)
        if (stored != null && preferences.getInt(KEY_BOOT_COUNT, -1) == bootCount) return stored

        return UUID.randomUUID().toString().also {
            preferences.edit().putString(KEY_BOOT_ID, it).putInt(KEY_BOOT_COUNT, bootCount).apply()
        }
    }

    /**
     * elapsed → epoch → elapsed 를 여러 번 읽어 앞뒤 elapsed 차가 가장 짧은 시도를 택한다.
     *
     * uncertainty_ms 산출 방법은 미정(정책서 합의 대기), 임시 측정.
     */
    override fun takeAnchor(): ClockAnchor {
        var best: ClockAnchor? = null
        repeat(ANCHOR_ATTEMPTS) {
            val before = SystemClock.elapsedRealtimeNanos()
            val epochMs = System.currentTimeMillis()
            val after = SystemClock.elapsedRealtimeNanos()
            val candidate =
                ClockAnchor(
                    elapsedNs = before + (after - before) / 2,
                    epochMs = epochMs,
                    uncertaintyMs = (after - before) / 2 / 1e6,
                )
            if (best == null || candidate.uncertaintyMs < best!!.uncertaintyMs) best = candidate
        }
        return best!!
    }

    private companion object {
        const val PREF_NAME = "widyu_clock"
        const val KEY_BOOT_ID = "boot_id"
        const val KEY_BOOT_COUNT = "boot_count"
        const val ANCHOR_ATTEMPTS = 5
    }
}
