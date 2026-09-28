package com.gbable.widu.di

import com.gbable.widu.data.source.ClockLocalDataSource
import com.gbable.widu.data.source.ClockLocalDataSourceImpl
import com.gbable.widu.data.source.FallDetectionLocalDataSource
import com.gbable.widu.data.source.FallDetectionLocalDataSourceImpl
import com.gbable.widu.data.source.FallEventRemoteDataSource
import com.gbable.widu.data.source.FallEventRemoteDataSourceImpl
import com.gbable.widu.data.source.HeartRateLocalDataSource
import com.gbable.widu.data.source.HeartRateLocalDataSourceImpl
import com.gbable.widu.data.source.HeartRateRemoteDataSource
import com.gbable.widu.data.source.HeartRateRemoteDataSourceImpl
import com.gbable.widu.data.source.ImuLocalDataSource
import com.gbable.widu.data.source.ImuLocalDataSourceImpl
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
    abstract fun bindFallDetectionLocalDataSource(impl: FallDetectionLocalDataSourceImpl): FallDetectionLocalDataSource

    @Binds
    @Singleton
    abstract fun bindFallEventRemoteDataSource(impl: FallEventRemoteDataSourceImpl): FallEventRemoteDataSource

    @Binds
    @Singleton
    abstract fun bindImuLocalDataSource(impl: ImuLocalDataSourceImpl): ImuLocalDataSource

    @Binds
    @Singleton
    abstract fun bindClockLocalDataSource(impl: ClockLocalDataSourceImpl): ClockLocalDataSource

    @Binds
    @Singleton
    abstract fun bindOnboardingLocalDataSource(impl: OnboardingLocalDataSourceImpl): OnboardingLocalDataSource
}
