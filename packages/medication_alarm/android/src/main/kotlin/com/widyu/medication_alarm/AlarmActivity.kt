package com.widyu.medication_alarm

import android.app.Activity
import android.app.KeyguardManager
import android.content.Intent
import android.graphics.Typeface
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.WindowManager
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.core.view.ViewCompat
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import org.json.JSONObject

class AlarmActivity : Activity() {
    private var group: JSONObject? = null
    private var verifying = false
    private val handler = Handler(Looper.getMainLooper())
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= 27) {
            setShowWhenLocked(true); setTurnScreenOn(true)
        } else window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        WindowCompat.setDecorFitsSystemWindows(window, false)
        WindowCompat.getInsetsController(window, window.decorView).apply {
            isAppearanceLightStatusBars = false
            isAppearanceLightNavigationBars = false
        }
        if (Build.VERSION.SDK_INT >= 33) onBackInvokedDispatcher.registerOnBackInvokedCallback(
            android.window.OnBackInvokedDispatcher.PRIORITY_DEFAULT
        ) { }
        showAlarm()
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent); setIntent(intent); showAlarm()
    }

    private fun showAlarm() {
        val state = synchronized(AlarmStore.lock) { AlarmStore.read(this) }
        val id = intent.getStringExtra("groupId")
        group = state.optJSONObject("activeGroup")?.takeIf { it.optString("groupId") == id }
            ?: AlarmStore.objects(AlarmStore.array(state, "scheduled"))
                .firstOrNull { it.optString("groupId") == id }
        if (group == null) {
            finish(); return
        }
        setContentView(R.layout.alarm_activity)
        val root = findViewById<android.view.View>(R.id.medication_alarm_root)
        ViewCompat.setOnApplyWindowInsetsListener(root) { view, insets ->
            val bars =
                insets.getInsets(WindowInsetsCompat.Type.systemBars() or WindowInsetsCompat.Type.displayCutout())
            view.setPadding(bars.left, bars.top, bars.right, bars.bottom)
            WindowInsetsCompat.CONSUMED
        }
        findViewById<ImageView>(R.id.medication_alarm_logo).setImageDrawable(asset("images/img_64_logo_medicine.png"))
        findViewById<ImageView>(R.id.medication_alarm_mascot).setImageDrawable(asset("images/img_93_mascot_medicine.png"))
        val bold = font("Pretendard-Bold.otf")
        val semibold = font("Pretendard-SemiBold.otf")
        val dose = AlarmStore.objects(group!!.getJSONArray("occurrences"))
            .sumOf { it.getDouble("doseCount") }
        findViewById<TextView>(R.id.medication_alarm_dose).apply {
            text = "${AlarmPlaybackService.doseLabel(dose)}정"; typeface = bold
        }
        listOf(
            R.id.medication_alarm_message,
            R.id.medication_alarm_verify,
            R.id.medication_alarm_stop
        )
            .forEach { findViewById<TextView>(it).typeface = semibold }
        findViewById<Button>(R.id.medication_alarm_verify).setOnClickListener { openVerification() }
        findViewById<Button>(R.id.medication_alarm_stop).setOnClickListener {
            MedicationAlarmPlugin.stop(this, group!!.getString("groupId")); finish()
        }
        if (intent.getBooleanExtra("verify", false)) openVerification()
        // Close an already-visible activity after completion, timeout or remote deletion.
        handler.removeCallbacksAndMessages(null)
        handler.postDelayed(object : Runnable {
            override fun run() {
                if (isFinishing || verifying) return
                val current = synchronized(AlarmStore.lock) { AlarmStore.read(this@AlarmActivity) }
                if (current.optJSONObject("activeGroup")?.optString("groupId") != id) finish()
                else handler.postDelayed(this, 1000)
            }
        }, 1000)
    }

    private fun openVerification() {
        if (verifying) return
        verifying = true
        val target = group ?: return
        // Save before dismissing the OS surface / starting a cold Flutter engine.
        AlarmStore.enqueueLaunch(this, target)
        MedicationAlarmPlugin.stop(this, target.getString("groupId"))
        fun launch() {
            val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            if (launchIntent != null) startActivity(launchIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP))
            finish()
        }

        val keyguard = getSystemService(KeyguardManager::class.java)
        if (keyguard.isKeyguardLocked) keyguard.requestDismissKeyguard(
            this,
            object : KeyguardManager.KeyguardDismissCallback() {
                override fun onDismissSucceeded() = launch()
                override fun onDismissCancelled() {
                    verifying = false
                }

                override fun onDismissError() {
                    verifying = false
                }
            }) else launch()
    }

    private fun asset(path: String) = try {
        assets.open("flutter_assets/assets/$path")
            .use { android.graphics.drawable.Drawable.createFromStream(it, null) }
    } catch (_: Exception) {
        null
    }

    private fun font(name: String) = try {
        Typeface.createFromAsset(assets, "flutter_assets/assets/fonts/$name")
    } catch (_: Exception) {
        Typeface.DEFAULT_BOLD
    }

    override fun onDestroy() {
        handler.removeCallbacksAndMessages(null); super.onDestroy()
    }
}
