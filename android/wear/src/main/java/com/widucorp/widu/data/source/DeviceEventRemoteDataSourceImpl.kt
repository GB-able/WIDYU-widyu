package com.widucorp.widu.data.source

import android.util.Log
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.PutDataMapRequest
import com.widucorp.widu.data.model.DeviceEvent
import com.widucorp.widu.data.util.awaitResult
import kotlinx.coroutines.CancellationException
import javax.inject.Inject

class DeviceEventRemoteDataSourceImpl @Inject constructor(
    private val dataClient: DataClient,
) : DeviceEventRemoteDataSource {
    /** 늦게 가도 되는 기록이라 setUrgent() 를 붙이지 않는다. [com.widucorp.widu.data.util.putBatch] 를 거치지 않아 SENT_TO_PHONE 에 세지 않는다. */
    override suspend fun send(event: DeviceEvent) {
        try {
            val request =
                PutDataMapRequest.create("$PREFIX/${event.eventId}").run {
                    dataMap.putByteArray(KEY_BODY, event.toJson().toString().toByteArray())
                    asPutDataRequest()
                }
            dataClient.putDataItem(request).awaitResult()
        } catch (exception: CancellationException) {
            throw exception
        } catch (exception: Exception) {
            Log.w(TAG, "Failed to send device event ${event.kind}", exception)
        }
    }

    private companion object {
        const val TAG = "Widyu"
        const val PREFIX = "/device_event"
        const val KEY_BODY = "body"
    }
}
