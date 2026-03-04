package com.example.widyu.data.source

import com.google.android.gms.wearable.MessageClient
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow
import javax.inject.Inject

class HeartRateStatusRemoteDataSourceImpl @Inject constructor(
    private val messageClient: MessageClient,
) : HeartRateStatusRemoteDataSource {
    override fun getHeartRateStatus(): Flow<String> =
        callbackFlow {
            val listener =
                MessageClient.OnMessageReceivedListener { messageEvent ->
                    if (messageEvent.path == RESPONSE_PATH) {
                        val heartRateStatus = String(messageEvent.data)
                        trySend(heartRateStatus)
                    }
                }

            messageClient.addListener(listener)

            awaitClose { messageClient.removeListener(listener) }
        }

    companion object {
        private const val RESPONSE_PATH = "/widyu_response"
    }
}
