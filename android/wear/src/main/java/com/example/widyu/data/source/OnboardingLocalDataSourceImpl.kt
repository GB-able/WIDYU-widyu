package com.example.widyu.data.source

import com.example.widyu.data.preference.OnboardingPreference
import javax.inject.Inject

class OnboardingLocalDataSourceImpl @Inject constructor(
    private val onboardingPreference: OnboardingPreference,
) : OnboardingLocalDataSource {
    override fun isOnboardingCompleted(): Boolean = onboardingPreference.isOnboardingCompleted()

    override fun setOnboardingCompleted() = onboardingPreference.setOnboardingFlag()
}
