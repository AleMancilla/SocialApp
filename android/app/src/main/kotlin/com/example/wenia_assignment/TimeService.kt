package com.alecodeando.weniatest

import android.app.Service
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import java.text.SimpleDateFormat
import java.util.*

class TimeService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private lateinit var runnable: Runnable

    override fun onCreate() {
        super.onCreate()

        // Inicializar el Runnable que imprime la hora
        runnable = object : Runnable {
            override fun run() {
                val sdf = SimpleDateFormat("HH:mm:ss", Locale.getDefault())
                val currentTime = sdf.format(Date())
                Log.d("TimeService", "Current time: $currentTime")

                // Repetir cada segundo
                handler.postDelayed(this, 1000)
            }
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Iniciar el Runnable
        handler.post(runnable)
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        // Detener el Runnable cuando el servicio se detenga
        handler.removeCallbacks(runnable)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
