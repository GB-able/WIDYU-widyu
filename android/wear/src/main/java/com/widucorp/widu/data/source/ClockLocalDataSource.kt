package com.widucorp.widu.data.source

import com.widucorp.widu.data.model.ClockAnchor

interface ClockLocalDataSource {
    /** 부팅 세대 식별자. 재부팅하면 바뀐다. */
    fun bootId(): String

    /** 단조 시각 ↔ 벽시계 앵커를 한 번 측정한다. */
    fun takeAnchor(): ClockAnchor
}
