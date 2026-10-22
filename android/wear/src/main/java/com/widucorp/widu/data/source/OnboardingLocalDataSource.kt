package com.widucorp.widu.data.source

interface OnboardingLocalDataSource {
    fun isOnboardingCompleted(): Boolean

    fun setOnboardingCompleted()
}
