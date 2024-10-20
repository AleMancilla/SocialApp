package com.alecodeando.weniatest

import android.app.usage.UsageStatsManager
import android.app.usage.UsageEvents
import android.content.Context
import android.app.Service
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log

class AppMonitorService : Service() {

    private val handler = Handler(Looper.getMainLooper())
    private var monitorRunnable: Runnable? = null
    private lateinit var usageStatsManager: UsageStatsManager
    private var lastAppPackage: String? = null
    private var appUsageTimes = mutableMapOf<String, Int>()
    private var appTimerRunnable: Runnable? = null

    override fun onCreate() {
        super.onCreate()
        usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        startMonitoring()
    }

    private fun startMonitoring() {
        monitorRunnable = object : Runnable {
            override fun run() {
                checkForegroundApp()
                handler.postDelayed(this, 1000) // Verificación cada segundo
            }
        }
        monitorRunnable?.let { handler.post(it) }
    }

    private fun checkForegroundApp() {
        val endTime = System.currentTimeMillis()
        val startTime = endTime - 1000

        val usageEvents = usageStatsManager.queryEvents(startTime, endTime)
        var lastEvent: UsageEvents.Event? = null

        // Recorre los eventos de uso
        while (usageEvents.hasNextEvent()) {
            val event = UsageEvents.Event()
            usageEvents.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                lastEvent = event // Guarda el último evento de "move to foreground"
            }
        }

        lastEvent?.let {
            val currentApp = it.packageName
            if (currentApp != lastAppPackage) {
                // Si se cambia de app, detiene el contador de la anterior
                lastAppPackage?.let { stopTimer(it) }
                // Inicia el contador para la nueva app
                startTimer(currentApp, appUsageTimes[currentApp] ?: 0)
                lastAppPackage = currentApp
            }
        }
    }

    private fun startTimer(packageName: String, initialTime: Int) {
        var secondsCounter = initialTime
        Log.d("AppMonitorService", "App abierta: $packageName")

        appTimerRunnable = object : Runnable {
            override fun run() {
                secondsCounter++
                appUsageTimes[packageName] = secondsCounter
                Log.d("AppMonitorService", "App en uso: $packageName - Tiempo: $secondsCounter segundos")
                handler.postDelayed(this, 1000) // Incrementa el contador cada segundo
            }
        }
        appTimerRunnable?.let { handler.post(it) }
    }

    private fun stopTimer(packageName: String) {
        appTimerRunnable?.let { handler.removeCallbacks(it) }
        val totalTime = appUsageTimes[packageName] ?: 0
        Log.d("AppMonitorService", "App cerrada: $packageName - Tiempo total: $totalTime segundos")
    }

    override fun onDestroy() {
        super.onDestroy()
        monitorRunnable?.let { handler.removeCallbacks(it) }
        appTimerRunnable?.let { handler.removeCallbacks(it) }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
