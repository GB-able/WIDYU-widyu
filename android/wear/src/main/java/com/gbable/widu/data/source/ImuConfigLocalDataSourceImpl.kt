package com.gbable.widu.data.source

import android.content.Context
import com.gbable.widu.data.model.ImuConfig
import dagger.hilt.android.qualifiers.ApplicationContext
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import javax.inject.Inject
import javax.inject.Singleton

/** 마지막 설정을 SharedPreferences 에 남겨 재기동 시 서버 응답을 기다리지 않는다. */
@Singleton
class ImuConfigLocalDataSourceImpl @Inject constructor(
    @ApplicationContext context: Context,
) : ImuConfigLocalDataSource {
    private val preferences = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
    private val state = MutableStateFlow(restore())

    override fun config(): StateFlow<ImuConfig> = state

    override fun apply(config: ImuConfig) {
        preferences
            .edit()
            .putString(KEY_COLLECTION_MODE, config.collectionMode)
            .putString(KEY_GYRO_MODE, config.gyroMode)
            .putInt(KEY_ACC_HZ, config.accHz)
            .putInt(KEY_BATCH_SEC, config.batchSec)
            .putFloat(KEY_IMPACT_G, config.impactG)
            .putInt(KEY_BACKFILL_PRE_SEC, config.backfillPreSec)
            .putInt(KEY_BACKFILL_POST_SEC, config.backfillPostSec)
            .apply()
        state.value = config
    }

    /** 서버가 주지 않는 필드(앵커 주기·큐 길이 등)는 기본값을 그대로 쓴다. */
    private fun restore(): ImuConfig {
        val default = ImuConfig()
        if (!preferences.contains(KEY_ACC_HZ)) return default
        return default.copy(
            collectionMode = preferences.getString(KEY_COLLECTION_MODE, default.collectionMode) ?: default.collectionMode,
            gyroMode = preferences.getString(KEY_GYRO_MODE, default.gyroMode) ?: default.gyroMode,
            accHz = preferences.getInt(KEY_ACC_HZ, default.accHz),
            batchSec = preferences.getInt(KEY_BATCH_SEC, default.batchSec),
            impactG = preferences.getFloat(KEY_IMPACT_G, default.impactG),
            backfillPreSec = preferences.getInt(KEY_BACKFILL_PRE_SEC, default.backfillPreSec),
            backfillPostSec = preferences.getInt(KEY_BACKFILL_POST_SEC, default.backfillPostSec),
        )
    }

    private companion object {
        const val PREF_NAME = "widyu_imu_config"
        const val KEY_COLLECTION_MODE = "collection_mode"
        const val KEY_GYRO_MODE = "gyro_mode"
        const val KEY_ACC_HZ = "acc_hz"
        const val KEY_BATCH_SEC = "batch_sec"
        const val KEY_IMPACT_G = "impact_g"
        const val KEY_BACKFILL_PRE_SEC = "backfill_pre_sec"
        const val KEY_BACKFILL_POST_SEC = "backfill_post_sec"
    }
}
