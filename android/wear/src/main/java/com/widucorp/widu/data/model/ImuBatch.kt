package com.widucorp.widu.data.model

/** 부록 A — IMU 배치 봉투. */
data class ImuBatch(
    val batchId: String,
    val deviceId: String,
    val sessionId: String,
    val seq: Long,
    val clock: ClockInfo,
    val acc: AxisSeries?,
    val gyro: AxisSeries? = null,
    val trigger: ImpactTrigger? = null,
    val gyroMode: String,
    val collectionMode: String,
    val gyroBackfill: Boolean = false,
    /** 보강 대상인 충격 배치의 batch_id. */
    val backfillFor: String? = null,
    val missingReason: String? = null,
    /** 서버가 boolean 필수로 받는다. */
    val onBody: Boolean,
    /** 미관측일 때만 `unknown` 을 싣는다. */
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
            "acc" to acc?.toMap("mg"),
            "gyro" to gyro?.toMap("mrads"),
            "trigger" to trigger?.toMap(),
            "gyro_backfill" to gyroBackfill,
            "backfill_for" to backfillFor,
            // 재전송 정보는 폰이 REST 로 다시 올릴 때 붙인다.
            "resend" to null,
            "collection_mode" to collectionMode,
            "gyro_mode" to gyroMode,
            "on_body" to onBody,
            "wear_state" to wearState,
            "missing_reason" to missingReason,
            "watch_battery_pct" to watchBatteryPct,
        )

    private companion object {
        const val VERSION = 2
        const val STREAM = "imu_watch"
        const val SOURCE = "watch"
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

private fun ImpactTrigger.toMap(): Map<String, Any?> =
    mapOf(
        "kind" to kind,
        "smv_g" to smvG,
        "event_elapsed_ns" to eventElapsedNs.toString(),
        "ts_ms" to tsMs,
    )

private fun AxisSeries.toMap(valuesKey: String): Map<String, Any?> =
    mapOf(
        "fs_hz_requested" to fsHzRequested,
        "n" to n,
        "t0_elapsed_ns" to t0ElapsedNs.toString(),
        "dt_ns" to dtNs.toList(),
        valuesKey to values.map { it.toList() },
    )
