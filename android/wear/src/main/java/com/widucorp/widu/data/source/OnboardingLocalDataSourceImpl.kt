package com.widucorp.widu.data.source

import com.widucorp.widu.data.preference.OnboardingPreference
import javax.inject.Inject

class OnboardingLocalDataSourceImpl @Inject constructor(
    private val onboardingPreference: OnboardingPreference,
) : OnboardingLocalDataSource {
    override fun isOnboardingCompleted(): Boolean = onboardingPreference.isOnboardingCompleted()

    override fun setOnboardingCompleted() = onboardingPreference.setOnboardingFlag()
}
