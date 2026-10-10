package com.gbable.widu.data.source

import android.annotation.SuppressLint
import android.content.Context
import android.os.BatteryManager
import android.provider.Settings
import android.util.Log
import com.gbable.widu.BuildConfig
import dagger.hilt.android.qualifiers.ApplicationContext
import java.io.BufferedWriter
import java.io.File
import java.io.FileOutputStream
import javax.inject.Inject

class DeviceInfoLocalDataSourceImpl @Inject constructor(
    @ApplicationContext private val context: Context,
) : DeviceInfoLocalDataSource {
    @SuppressLint("HardwareIds")
    override fun deviceId(): String = "gw-" + Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)

    override fun batteryPercent(): Int? =
        runCatching {
            (context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager)
                .getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        }.getOrNull()

    /** adb pull 로 꺼낸다. */
    override fun openRawLog(): BufferedWriter? {
        if (!BuildConfig.DEBUG) return null
        return runCatching {
            FileOutputStream(File(context.filesDir, "imu_raw.csv"), true).bufferedWriter()
        }.onFailure { Log.w("Widyu", "Failed to open raw IMU log", it) }.getOrNull()
    }
}
