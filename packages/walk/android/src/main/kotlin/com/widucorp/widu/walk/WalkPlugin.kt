package com.widucorp.widu.walk

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.fitness.FitnessLocal
import com.google.android.gms.fitness.LocalRecordingClient
import com.google.android.gms.fitness.data.LocalDataType
import com.google.android.gms.fitness.data.LocalField
import com.google.android.gms.fitness.request.LocalDataReadRequest
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit

class WalkPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.widucorp.widu/walk")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            if (call.method == "isAvailable") {
                result.success(isAvailable())
                return
            }
            if (call.method !in setOf("startRecording", "stopRecording", "readSteps")) {
                result.notImplemented()
                return
            }
            if (!isAvailable()) {
                result.error("UNAVAILABLE", "Google Play 서비스를 설치하거나 업데이트해 주세요.", null)
                return
            }
            val client = FitnessLocal.getLocalRecordingClient(context)
            if (call.method == "stopRecording") {
                client.unsubscribe(LocalDataType.TYPE_STEP_COUNT_DELTA)
                    .addOnSuccessListener { result.success(null) }
                    .addOnFailureListener { fail(result, it) }
                return
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q &&
                context.checkSelfPermission(Manifest.permission.ACTIVITY_RECOGNITION) !=
                PackageManager.PERMISSION_GRANTED
            ) {
                result.error("PERMISSION_DENIED", "신체 활동 권한이 필요합니다.", null)
                return
            }
            when (call.method) {
                "startRecording" -> client.subscribe(LocalDataType.TYPE_STEP_COUNT_DELTA)
                    .addOnSuccessListener { result.success(null) }
                    .addOnFailureListener { fail(result, it) }
                "readSteps" -> readSteps(client, call, result)
            }
        } catch (error: Exception) {
            fail(result, error)
        }
    }

    private fun isAvailable(): Boolean =
        GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(
            context,
            LocalRecordingClient.LOCAL_RECORDING_CLIENT_MIN_VERSION_CODE
        ) == ConnectionResult.SUCCESS

    private fun readSteps(
        client: LocalRecordingClient,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val start = call.argument<Number>("startMillis")!!.toLong()
        val end = call.argument<Number>("endMillis")!!.toLong()
        val request = LocalDataReadRequest.Builder()
            .aggregate(LocalDataType.TYPE_STEP_COUNT_DELTA)
            .bucketByTime(1, TimeUnit.DAYS)
            .setTimeRange(start, end, TimeUnit.MILLISECONDS)
            .build()
        client.subscribe(LocalDataType.TYPE_STEP_COUNT_DELTA)
            .continueWithTask { subscription ->
                subscription.getResult(Exception::class.java)
                client.readData(request)
            }
            .addOnSuccessListener { response ->
                val points = response.buckets.flatMap { bucket ->
                    bucket.dataSets.flatMap { it.dataPoints }
                }
                result.success(
                    if (points.isEmpty()) null
                    else points.sumOf { it.getValue(LocalField.FIELD_STEPS).asInt().toLong() }
                )
            }
            .addOnFailureListener { fail(result, it) }
    }

    private fun fail(result: MethodChannel.Result, error: Exception) {
        val code = when {
            error is SecurityException -> "PERMISSION_DENIED"
            error is ApiException && error.statusCode in setOf(
                ConnectionResult.API_UNAVAILABLE,
                ConnectionResult.SERVICE_VERSION_UPDATE_REQUIRED
            ) -> "UNAVAILABLE"
            else -> "RECORDING_FAILED"
        }
        result.error(code, error.message, null)
    }
}
