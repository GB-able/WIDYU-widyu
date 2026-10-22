package com.widucorp.widu.di

import com.widucorp.widu.data.source.ClockLocalDataSource
import com.widucorp.widu.data.source.ClockLocalDataSourceImpl
import com.widucorp.widu.data.source.DeviceInfoLocalDataSource
import com.widucorp.widu.data.source.DeviceInfoLocalDataSourceImpl
import com.widucorp.widu.data.source.HeartRateLocalDataSource
import com.widucorp.widu.data.source.HeartRateLocalDataSourceImpl
import com.widucorp.widu.data.source.HeartRateRemoteDataSource
import com.widucorp.widu.data.source.HeartRateRemoteDataSourceImpl
import com.widucorp.widu.data.source.ImuConfigLocalDataSource
import com.widucorp.widu.data.source.ImuConfigLocalDataSourceImpl
import com.widucorp.widu.data.source.ImuLocalDataSource
import com.widucorp.widu.data.source.ImuLocalDataSourceImpl
import com.widucorp.widu.data.source.ImuRemoteDataSource
import com.widucorp.widu.data.source.ImuRemoteDataSourceImpl
import com.widucorp.widu.data.source.OnboardingLocalDataSource
import com.widucorp.widu.data.source.OnboardingLocalDataSourceImpl
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
    abstract fun bindImuLocalDataSource(impl: ImuLocalDataSourceImpl): ImuLocalDataSource

    @Binds
    @Singleton
    abstract fun bindImuConfigLocalDataSource(impl: ImuConfigLocalDataSourceImpl): ImuConfigLocalDataSource

    @Binds
    @Singleton
    abstract fun bindImuRemoteDataSource(impl: ImuRemoteDataSourceImpl): ImuRemoteDataSource

    @Binds
    @Singleton
    abstract fun bindDeviceInfoLocalDataSource(impl: DeviceInfoLocalDataSourceImpl): DeviceInfoLocalDataSource

    @Binds
    @Singleton
    abstract fun bindClockLocalDataSource(impl: ClockLocalDataSourceImpl): ClockLocalDataSource

    @Binds
    @Singleton
    abstract fun bindOnboardingLocalDataSource(impl: OnboardingLocalDataSourceImpl): OnboardingLocalDataSource
}
