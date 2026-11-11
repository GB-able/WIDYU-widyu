package com.widucorp.widu.medication_alarm

import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class EffectivePeriodTest {
    @Test
    fun includesBothEnds() {
        assertTrue(isEffective("2026-10-01", "2026-10-01", "2026-11-09"))
        assertTrue(isEffective("2026-11-09", "2026-10-01", "2026-11-09"))
    }

    @Test
    fun excludesDatesOutsidePeriod() {
        assertFalse(isEffective("2026-09-30", "2026-10-01", "2026-11-09"))
        assertFalse(isEffective("2026-11-10", "2026-10-01", "2026-11-09"))
    }

    @Test
    fun nullEndsAreOpen() {
        assertTrue(isEffective("2099-01-01", "2026-11-10", null))
        assertFalse(isEffective("2026-11-09", "2026-11-10", null))
        assertTrue(isEffective("2000-01-01", null, "2026-11-09"))
        assertTrue(isEffective("2026-11-09", null, null))
    }
}
