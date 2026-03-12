package com.example.widyu.presentation

import android.util.Log
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.example.widyu.data.repository.HeartRateRepository
import kotlinx.coroutines.launch
import javax.inject.Inject

class AppLifecycleObserver @Inject constructor(
    private val repository: HeartRateRepository,
) : DefaultLifecycleObserver {
    override fun onStart(owner: LifecycleOwner) {
        owner.lifecycleScope.launch {
            repository
                .stopPassiveMonitoring()
                .onSuccess { Log.i("Widyu", "stopPassiveMonitoring") }
                .onFailure { Log.i("Widyu", "Error in onStart", it) }
        }
    }

    override fun onStop(owner: LifecycleOwner) {
        owner.lifecycleScope.launch {
            repository
                .startPassiveMonitoring()
                .onSuccess { Log.i("Widyu", "startPassiveMonitoring") }
                .onFailure { Log.i("Widyu", "Error in onStop", it) }
        }
    }
}
