package com.widucorp.widu.data.source

import android.content.Context
import com.widucorp.widu.data.model.ImuConfig
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
            .apply()
        state.value = config
    }

    /** 서버가 주지 않거나 고정인 필드(측정 주기·배치 길이·앵커 주기 등)는 기본값을 그대로 쓴다. */
    private fun restore(): ImuConfig {
        val default = ImuConfig()
        if (!preferences.contains(KEY_COLLECTION_MODE)) return default
        return default.copy(
            collectionMode = preferences.getString(KEY_COLLECTION_MODE, default.collectionMode) ?: default.collectionMode,
            gyroMode = preferences.getString(KEY_GYRO_MODE, default.gyroMode) ?: default.gyroMode,
        )
    }

    private companion object {
        const val PREF_NAME = "widyu_imu_config"
        const val KEY_COLLECTION_MODE = "collection_mode"
        const val KEY_GYRO_MODE = "gyro_mode"
    }
}
