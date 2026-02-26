package com.example.widyu.di

import android.content.Context
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.Wearable
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DataClientModule {
    @Provides
    @Singleton
    fun provideDataClient(
        @ApplicationContext context: Context,
    ): DataClient = Wearable.getDataClient(context)
}
