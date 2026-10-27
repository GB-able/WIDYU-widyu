package com.widucorp.widu.data.preference

import android.content.Context
import android.content.SharedPreferences
import androidx.core.content.edit

class OnboardingPreference(
    context: Context,
) {
    private val preferences: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

    fun setOnboardingFlag() = preferences.edit { putBoolean(KEY_ONBOARDING_COMPLETE, true) }

    fun isOnboardingCompleted(): Boolean = preferences.getBoolean(KEY_ONBOARDING_COMPLETE, false)

    companion object {
        private const val PREFS_NAME = "Onboarding"
        private const val KEY_ONBOARDING_COMPLETE = "Onboarding_Complete"
    }
}
