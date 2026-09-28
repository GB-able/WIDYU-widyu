package com.gbable.widu.data.model

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
    /** 직전 2초 자이로를 따로 싣는 보강 배치인가. */
    val gyroBackfill: Boolean = false,
    /** 보강 대상인 충격 배치의 batch_id. */
    val backfillFor: String? = null,
    val missingReason: String? = null,
    val onBody: Boolean? = null,
    val watchBatteryPct: Int? = null,
    val studyId: String? = null,
    val participationId: String? = null,
    val runId: String? = null,
) {
    val v: Int get() = VERSION
    val stream: String get() = STREAM
    val source: String get() = SOURCE

    /**
     * 부록 A 형식의 키/값. JSON 직렬화는 [ImuBatchJson] 이 얇게 감싼다.
     * 나노초 값은 자바스크립트 정수 범위를 넘으므로 10진 문자열로 싣는다.
     */
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
            "clock" to
                mapOf(
                    "boot_id" to clock.bootId,
                    "clock_mapping_id" to clock.clockMappingId,
                    "anchor_elapsed_ns" to clock.anchorElapsedNs.toString(),
                    "anchor_epoch_ms" to clock.anchorEpochMs,
                    "uncertainty_ms" to clock.uncertaintyMs,
                ),
            // 최상위에도 둔다 — 서버가 clock{} 을 펼치지 않고도 세대를 가릴 수 있게.
            "boot_id" to clock.bootId,
            "clock_mapping_id" to clock.clockMappingId,
            "acc" to acc?.toMap("mg"),
            "gyro" to gyro?.toMap("mrads"),
            "trigger" to trigger?.toMap(),
            "gyro_backfill" to gyroBackfill,
            "backfill_for" to backfillFor,
            "gyro_mode" to gyroMode,
            "collection_mode" to collectionMode,
            "missing_reason" to missingReason,
            "on_body" to onBody,
            "watch_battery_pct" to watchBatteryPct,
        )

    private companion object {
        const val VERSION = 2
        const val STREAM = "imu_watch"
        const val SOURCE = "watch"
    }
}

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
