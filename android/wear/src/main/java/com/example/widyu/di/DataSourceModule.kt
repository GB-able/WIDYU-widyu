package com.example.widyu.di

import com.example.widyu.data.source.HeartRateLocalDataSource
import com.example.widyu.data.source.HeartRateLocalDataSourceImpl
import com.example.widyu.data.source.HeartRateRemoteDataSource
import com.example.widyu.data.source.HeartRateRemoteDataSourceImpl
import com.example.widyu.data.source.HeartRateStatusRemoteDataSource
import com.example.widyu.data.source.HeartRateStatusRemoteDataSourceImpl
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
    abstract fun bindHeartRateStatusRemoteDataSource(impl: HeartRateStatusRemoteDataSourceImpl): HeartRateStatusRemoteDataSource
}
