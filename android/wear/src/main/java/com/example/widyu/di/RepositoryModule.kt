package com.example.widyu.di

import HeartRateRepository
import com.example.widyu.data.repository.HeartRateRepositoryImpl
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
}
