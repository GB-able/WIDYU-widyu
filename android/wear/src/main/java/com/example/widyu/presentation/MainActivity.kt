package com.example.widyu.presentation

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.example.widyu.data.service.HeartRateForegroundService
import com.example.widyu.presentation.component.WidyuApp
import com.example.widyu.presentation.theme.WidyuTheme
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            WidyuTheme {
                WidyuApp()
            }
        }
        handleRestartIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleRestartIntent(intent)
    }

    private fun handleRestartIntent(intent: Intent?) {
        if (intent?.getBooleanExtra(EXTRA_RESTART_SESSION, false) == true) {
            startForegroundService(HeartRateForegroundService.restartSessionIntent(this))
        }
    }

    companion object {
        private const val EXTRA_RESTART_SESSION = "extra_restart_session"

        fun newIntent(context: Context): Intent = Intent(context, MainActivity::class.java)

        fun newRestartIntent(context: Context): Intent =
            newIntent(context).apply {
                putExtra(EXTRA_RESTART_SESSION, true)
                flags = Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
    }
}
