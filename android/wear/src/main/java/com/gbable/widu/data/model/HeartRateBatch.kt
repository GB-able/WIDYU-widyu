package com.gbable.widu.data.model

/** Health Services 가 준 샘플 그대로. 시각은 부팅 기준 경과 시각이고 정확도로 거르지 않는다. (A 1.2.1) */
data class HeartRateReading(
    val bpm: Int,
    val elapsedNs: Long,
    val accuracy: String,
)

/** 서버 심박 배치의 샘플. [tsMs] 는 잰 시각(epoch ms)이며 배치 안에서 엄격히 증가한다. */
data class HeartRateSample(
    val bpm: Int,
    val tsMs: Long,
    val accuracy: String,
)

/** 서버가 받는 정확도 값. 아직 모르면 null 대신 [UNKNOWN] 을 보낸다. */
object HeartRateAccuracyLabel {
    const val HIGH = "HIGH"
    const val MEDIUM = "MEDIUM"
    const val LOW = "LOW"
    const val UNRELIABLE = "UNRELIABLE"
    const val UNKNOWN = "UNKNOWN"
}

/** 심박 배치 v2 봉투(`stream: "hr"`). IMU 와 같은 경로·재전송 규칙을 쓴다. */
data class HeartRateBatch(
    val batchId: String,
    val deviceId: String,
    val sessionId: String,
    val seq: Long,
    val clock: ClockInfo,
    val samples: List<HeartRateSample>,
    val onBody: Boolean,
    val watchBatteryPct: Int? = null,
    val studyId: String? = null,
    val participationId: String? = null,
    val runId: String? = null,
) {
    fun toMap(): Map<String, Any?> =
        mapOf(
            "v" to VERSION,
            "stream" to STREAM,
            "batch_id" to batchId,
            "device_id" to deviceId,
            "session_id" to sessionId,
            "seq" to seq,
            "study_id" to studyId,
            "participation_id" to participationId,
            "run_id" to runId,
            "clock" to clock.toMap(),
            "samples" to samples.map { mapOf("bpm" to it.bpm, "ts_ms" to it.tsMs, "accuracy" to it.accuracy) },
            "on_body" to onBody,
            "watch_battery_pct" to watchBatteryPct,
            "resend" to null,
        )

    private companion object {
        const val VERSION = 2
        const val STREAM = "hr"
    }
}
