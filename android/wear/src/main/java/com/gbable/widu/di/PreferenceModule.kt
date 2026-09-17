package com.gbable.widu.di

import android.content.Context
import com.gbable.widu.data.preference.OnboardingPreference
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object PreferenceModule {
    @Provides
    @Singleton
    fun provideOnboardingPreference(
        @ApplicationContext context: Context,
    ): OnboardingPreference = OnboardingPreference(context)
}
