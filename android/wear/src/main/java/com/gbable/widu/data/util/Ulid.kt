package com.gbable.widu.data.util

import java.security.SecureRandom

/**
 * 서버가 `batch_id` 로 요구하는 소문자 ULID 26자 — 48비트 epoch ms + 80비트 난수, Crockford Base32.
 * 같은 ms 안의 순서는 보장되지 않으므로 정렬은 seq 로 한다.
 */
private const val ALPHABET = "0123456789abcdefghjkmnpqrstvwxyz"

private val RANDOM = SecureRandom()

fun newUlid(): String {
    val time = System.currentTimeMillis()
    val builder = StringBuilder(26)
    for (index in 0 until 10) builder.append(ALPHABET[((time ushr (45 - 5 * index)) and 0x1fL).toInt()])
    repeat(2) {
        val part = RANDOM.nextLong() and 0xff_ffff_ffffL
        for (index in 0 until 8) builder.append(ALPHABET[((part ushr (35 - 5 * index)) and 0x1fL).toInt()])
    }
    return builder.toString()
}
