package com.example.widyu.data.source

interface OnboardingLocalDataSource {
    fun isOnboardingCompleted(): Boolean

    fun setOnboardingCompleted()
}
