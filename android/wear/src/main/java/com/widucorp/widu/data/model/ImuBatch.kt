package com.widucorp.widu.data.model

/** 부록 A — IMU 배치 봉투. */
data class ImuBatch(
    val batchId: String,
    val deviceId: String,
    val sessionId: String,
    val seq: Long,
    val clock: ClockInfo,
    val acc: AxisSeries,
    val gyroMode: String,
    val collectionMode: String,
    /** 서버가 boolean 필수로 받는다. */
    val onBody: Boolean,
    /** [com.widucorp.widu.data.util.WearState] 값. */
    val wearState: String? = null,
    val watchBatteryPct: Int? = null,
    val studyId: String? = null,
    val participationId: String? = null,
    val runId: String? = null,
) {
    val v: Int get() = VERSION
    val stream: String get() = STREAM
    val source: String get() = SOURCE

    /** 나노초 값은 자바스크립트 정수 범위를 넘으므로 10진 문자열로 싣는다. */
    fun toMap(): Map<String, Any?> =
        mapOf(
            "v" to VERSION,
            "stream" to STREAM,
            "source" to SOURCE,
            "batch_id" to batchId,
            "device_id" to deviceId,
            "session_id" to sessionId,
            "seq" to seq,
            "study_id" to studyId,
            "participation_id" to participationId,
            "run_id" to runId,
            "clock" to clock.toMap(),
            "acc" to acc.toMap("mg"),
            // 자이로·충격 감지는 하지 않는다. 키는 서버 스펙이라 남긴다.
            "gyro" to null,
            "trigger" to null,
            "gyro_backfill" to false,
            "backfill_for" to null,
            // 재전송 정보는 폰이 REST 로 다시 올릴 때 붙인다.
            "resend" to null,
            "collection_mode" to collectionMode,
            "gyro_mode" to gyroMode,
            "on_body" to onBody,
            "wear_state" to wearState,
            "missing_reason" to MISSING_REASON,
            "watch_battery_pct" to watchBatteryPct,
        )

    private companion object {
        const val VERSION = 2
        const val STREAM = "imu_watch"
        const val SOURCE = "watch"

        /** 자이로 결측 사유 (A 1.2.6). */
        const val MISSING_REASON = "omitted_by_mode"
    }
}

/** 나노초 값은 자바스크립트 정수 범위를 넘으므로 10진 문자열로 싣는다. */
internal fun ClockInfo.toMap(): Map<String, Any?> =
    mapOf(
        "boot_id" to bootId,
        "clock_mapping_id" to clockMappingId,
        "anchor_elapsed_ns" to anchorElapsedNs.toString(),
        "anchor_epoch_ms" to anchorEpochMs,
        "uncertainty_ms" to uncertaintyMs,
    )

private fun AxisSeries.toMap(valuesKey: String): Map<String, Any?> =
    mapOf(
        "fs_hz_requested" to fsHzRequested,
        "n" to n,
        "t0_elapsed_ns" to t0ElapsedNs.toString(),
        "dt_ns" to dtNs.toList(),
        valuesKey to values.map { it.toList() },
    )
