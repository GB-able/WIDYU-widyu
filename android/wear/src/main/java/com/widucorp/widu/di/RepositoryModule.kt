package com.widucorp.widu.di

import com.widucorp.widu.data.repository.HeartRateRepository
import com.widucorp.widu.data.repository.HeartRateRepositoryImpl
import com.widucorp.widu.data.repository.ImuRepository
import com.widucorp.widu.data.repository.ImuRepositoryImpl
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
    abstract fun bindImuRepository(impl: ImuRepositoryImpl): ImuRepository
}
