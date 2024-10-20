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
import java.util.Calendar

class AppMonitorService : Service() {

    private val handler = Handler(Looper.getMainLooper())
    private var monitorRunnable: Runnable? = null
    private lateinit var usageStatsManager: UsageStatsManager
    private var lastAppPackage: String? = null
    private var appTimerRunnable: Runnable? = null
    private var totalUsageTime = 0 // Tiempo de uso total en segundos

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

        while (usageEvents.hasNextEvent()) {
            val event = UsageEvents.Event()
            usageEvents.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                lastEvent = event
            }
        }

        lastEvent?.let {
            val currentApp = it.packageName

            // Ignorar el widget flotante en el monitoreo
            if (currentApp == "com.alecodeando.weniatest") {
                return
            }

            if (currentApp != lastAppPackage) {
                lastAppPackage?.let { stopTracking(it) }
                startTracking(currentApp)
                lastAppPackage = currentApp
            }
        }
    }

    private fun startTracking(packageName: String) {
        totalUsageTime = getAppUsageTime(packageName) // Obtener tiempo total acumulado
        Log.d("AppMonitorService", "App abierta: $packageName - Tiempo acumulado: ${formatTime(totalUsageTime)}")

        appTimerRunnable = object : Runnable {
            override fun run() {
                totalUsageTime++
                val formattedTime = formatTime(totalUsageTime)
                Log.d("AppMonitorService", "App en uso: $packageName - Tiempo: $formattedTime")

                // Enviar el tiempo de uso al servicio del widget flotante
                val intent = Intent(this@AppMonitorService, FloatingWidgetService::class.java)
                intent.putExtra("usage_time", formattedTime)
                startService(intent)

                handler.postDelayed(this, 1000) // Incrementa el contador cada segundo
            }
        }
        appTimerRunnable?.let { handler.post(it) }
    }

    private fun stopTracking(packageName: String) {
        appTimerRunnable?.let { handler.removeCallbacks(it) }
        val totalUsageTimeNow = getAppUsageTime(packageName) // Obtener tiempo acumulado desde el sistema
        Log.d("AppMonitorService", "App cerrada: $packageName - Tiempo total: ${formatTime(totalUsageTimeNow)}")
    }

    private fun getAppUsageTime(packageName: String): Int {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)

        val usageStatsList = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            calendar.timeInMillis,
            System.currentTimeMillis()
        )

        for (usageStats in usageStatsList) {
            if (usageStats.packageName == packageName) {
                return (usageStats.totalTimeInForeground / 1000).toInt() // Convertir de milisegundos a segundos
            }
        }

        return 0 // Si no se encontró el paquete, retorna 0
    }

    // Función para formatear el tiempo en HH:MM:SS
    private fun formatTime(seconds: Int): String {
        val hours = seconds / 3600
        val minutes = (seconds % 3600) / 60
        val secs = seconds % 60
        return String.format("%02d:%02d:%02d", hours, minutes, secs)
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
