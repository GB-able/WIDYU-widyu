package com.example.widyu.presentation

import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.example.widyu.data.repository.HeartRateRepository
import javax.inject.Inject

class AppLifecycleObserver @Inject constructor(
    private val repository: HeartRateRepository,
) : DefaultLifecycleObserver {
    override fun onStart(owner: LifecycleOwner) {
        repository.stopPassiveMonitoring()
    }

    override fun onStop(owner: LifecycleOwner) {
        repository.startPassiveMonitoring()
    }
}
