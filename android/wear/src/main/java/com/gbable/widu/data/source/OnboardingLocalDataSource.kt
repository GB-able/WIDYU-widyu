package com.gbable.widu.data.source

interface OnboardingLocalDataSource {
    fun isOnboardingCompleted(): Boolean

    fun setOnboardingCompleted()
}
