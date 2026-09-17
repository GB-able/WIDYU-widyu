package com.gbable.widu.di

import com.gbable.widu.data.source.HeartRateLocalDataSource
import com.gbable.widu.data.source.HeartRateLocalDataSourceImpl
import com.gbable.widu.data.source.HeartRateRemoteDataSource
import com.gbable.widu.data.source.HeartRateRemoteDataSourceImpl
import com.gbable.widu.data.source.OnboardingLocalDataSource
import com.gbable.widu.data.source.OnboardingLocalDataSourceImpl
import dagger.Binds
import dagger.Module
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
abstract class DataSourceModule {
    @Binds
    @Singleton
    abstract fun bindHeartRateLocalDataSource(impl: HeartRateLocalDataSourceImpl): HeartRateLocalDataSource

    @Binds
    @Singleton
    abstract fun bindHeartRateRemoteDataSource(impl: HeartRateRemoteDataSourceImpl): HeartRateRemoteDataSource

    @Binds
    @Singleton
    abstract fun bindOnboardingLocalDataSource(impl: OnboardingLocalDataSourceImpl): OnboardingLocalDataSource
}
