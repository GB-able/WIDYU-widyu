package com.widucorp.widu.di

import android.content.Context
import androidx.health.services.client.HealthServices
import androidx.health.services.client.HealthServicesClient
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object HealthClientModule {
    @Provides
    @Singleton
    fun provideHealthClient(
        @ApplicationContext context: Context,
    ): HealthServicesClient = HealthServices.getClient(context)
}
