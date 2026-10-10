package com.gbable.widu.di

import com.gbable.widu.data.repository.HeartRateRepository
import com.gbable.widu.data.repository.HeartRateRepositoryImpl
import com.gbable.widu.data.repository.ImuRepository
import com.gbable.widu.data.repository.ImuRepositoryImpl
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
