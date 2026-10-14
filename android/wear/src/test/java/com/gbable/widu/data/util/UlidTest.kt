package com.gbable.widu.data.util

import io.kotest.matchers.shouldBe
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test

class UlidTest {
    @Test
    @DisplayName("소문자 Crockford Base32 26자를 만든다")
    fun shapeMatchesTheSpec() {
        repeat(100) {
            val ulid = newUlid()
            ulid.length shouldBe 26
            ulid.all { it in "0123456789abcdefghjkmnpqrstvwxyz" } shouldBe true
        }
    }

    @Test
    @DisplayName("100개를 만들어도 겹치지 않는다")
    fun idsDoNotCollide() {
        val ids = List(100) { newUlid() }
        ids.toSet().size shouldBe 100
    }

    @Test
    @DisplayName("앞 10자는 시각 순으로 단조 증가한다")
    fun timePrefixIsMonotonic() {
        val prefixes = List(50) { newUlid().take(10) }
        prefixes.zipWithNext().all { (previous, next) -> previous <= next } shouldBe true
    }
}
