package com.gbable.widu.di

import com.gbable.widu.data.repository.FallDetectionRepository
import com.gbable.widu.data.repository.FallDetectionRepositoryImpl
import com.gbable.widu.data.repository.HeartRateRepository
import com.gbable.widu.data.repository.HeartRateRepositoryImpl
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class RepositoryModule {
    @Binds
    @Singleton
    abstract fun bindHeartRateRepository(impl: HeartRateRepositoryImpl): HeartRateRepository

    @Binds
    @Singleton
    abstract fun bindFallDetectionRepository(impl: FallDetectionRepositoryImpl): FallDetectionRepository
}
