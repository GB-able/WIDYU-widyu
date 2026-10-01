package com.widyu.medication_alarm

import android.app.Activity
import android.app.KeyguardManager
import android.content.Intent
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import org.json.JSONObject
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter
import java.util.Locale

class AlarmActivity : Activity() {
    private val orange = Color.rgb(255, 119, 15)
    private var group: JSONObject? = null
    private var verifying = false
    private val handler = Handler(Looper.getMainLooper())
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= 27) { setShowWhenLocked(true); setTurnScreenOn(true) }
        else window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        showAlarm()
    }
    override fun onNewIntent(intent: Intent) { super.onNewIntent(intent); setIntent(intent); showAlarm() }
    private fun showAlarm() {
        val state = synchronized(AlarmStore.lock) { AlarmStore.read(this) }
        val id = intent.getStringExtra("groupId")
        group = state.optJSONObject("activeGroup")?.takeIf { it.optString("groupId") == id }
            ?: AlarmStore.objects(AlarmStore.array(state, "scheduled")).firstOrNull { it.optString("groupId") == id }
        if (group == null) { finish(); return }
        val content = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL; gravity = Gravity.CENTER_HORIZONTAL
            setPadding(dp(32), dp(40), dp(32), dp(28))
            background = GradientDrawable(GradientDrawable.Orientation.TL_BR,
                intArrayOf(Color.rgb(31, 28, 32), Color.rgb(14, 13, 18), Color.rgb(36, 29, 34)))
        }
        val now = ZonedDateTime.now()
        content.addView(text(now.format(DateTimeFormatter.ofPattern("M월 d일 (E)", Locale.KOREAN)), 16f, Color.LTGRAY))
        content.addView(text(now.format(DateTimeFormatter.ofPattern("HH:mm")), 54f, Color.WHITE))
        content.addView(text("위듀", 27f, orange))
        content.addView(android.view.View(this), LinearLayout.LayoutParams(1, 0, 1f))
        val mascot = ImageView(this).apply {
            contentDescription = "약을 든 위듀 캐릭터"
            try { assets.open("flutter_assets/assets/images/img_238_medicine.png").use {
                setImageDrawable(android.graphics.drawable.Drawable.createFromStream(it, null))
            } } catch (_: Exception) { }
            scaleType = ImageView.ScaleType.FIT_CENTER
        }
        content.addView(mascot, LinearLayout.LayoutParams(dp(185), dp(185)))
        val dose = AlarmStore.objects(group!!.getJSONArray("occurrences")).sumOf { it.getDouble("doseCount") }
        content.addView(text("${AlarmPlaybackService.doseLabel(dose)}정", 28f, orange))
        content.addView(text("복용하실 시간이에요!", 21f, Color.WHITE).apply { setPadding(0, dp(12), 0, dp(24)) })
        content.addView(button("인증하러 가기", orange) { openVerification() }, LinearLayout.LayoutParams(-1, dp(60)))
        content.addView(android.view.View(this), LinearLayout.LayoutParams(1, 0, 1.3f))
        content.addView(button("중단", Color.rgb(48, 48, 48)) {
            MedicationAlarmPlugin.stop(this, group!!.getString("groupId")); finish()
        }, LinearLayout.LayoutParams(dp(108), dp(48)))
        setContentView(content)
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
        if (keyguard.isKeyguardLocked) keyguard.requestDismissKeyguard(this, object : KeyguardManager.KeyguardDismissCallback() {
            override fun onDismissSucceeded() = launch()
            override fun onDismissCancelled() { verifying = false }
            override fun onDismissError() { verifying = false }
        }) else launch()
    }
    private fun text(label: String, size: Float, color: Int) = TextView(this).apply {
        text = label; textSize = size; setTextColor(color); gravity = Gravity.CENTER
        typeface = Typeface.create("sans-serif-medium", Typeface.BOLD)
    }
    private fun button(label: String, color: Int, action: () -> Unit) = Button(this).apply {
        text = label; textSize = 18f; setTextColor(Color.WHITE); isAllCaps = false
        background = GradientDrawable().apply { setColor(color); cornerRadius = dp(32).toFloat() }
        setOnClickListener { action() }
    }
    private fun dp(value: Int) = (value * resources.displayMetrics.density).toInt()
    override fun onDestroy() { handler.removeCallbacksAndMessages(null); super.onDestroy() }
}
