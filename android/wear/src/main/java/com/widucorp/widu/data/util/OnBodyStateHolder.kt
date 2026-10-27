package com.widucorp.widu.data.util

import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import javax.inject.Inject
import javax.inject.Singleton

/** 착용 여부. Health Services 가용성 콜백만이 알려주므로 심박 세션이 도는 동안만 갱신되고, null 은 「아직 모른다」다. */
@Singleton
class OnBodyStateHolder @Inject constructor() {
    private val _state = MutableStateFlow<Boolean?>(null)
    val state: StateFlow<Boolean?> = _state

    fun update(isOnBody: Boolean?) {
        _state.value = isOnBody
    }
}
