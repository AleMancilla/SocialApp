package com.alecodeando.weniatest

import android.accessibilityservice.AccessibilityService
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.os.Handler
import android.os.Looper

class AppMonitorService : AccessibilityService() {

    private var lastAppPackage: String? = null
    private var handler: Handler? = null
    private var runnable: Runnable? = null
    private val appUsageTimes = mutableMapOf<String, Int>() // Almacena el tiempo acumulado de cada app
    private var isAppForeground = false

   override fun onAccessibilityEvent(event: AccessibilityEvent?) {
    if (event == null) return

    val packageName = event.packageName?.toString()

    // Verificar si la aplicación ha cambiado o si es un cambio de estado en la misma app
    if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED || 
        event.eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED) {

        if (packageName != null) {
            // Si la aplicación no ha cambiado pero vuelve al primer plano desde segundo plano
            if (packageName == lastAppPackage && !isAppForeground) {
                Log.d("AppMonitorService", "App volvió al primer plano: ${getAppNameFromPackage(packageName)}")

                // Restaurar el tiempo de uso si ya existe
                val previousTime = appUsageTimes[packageName] ?: 0
                Log.d("AppMonitorService", "App abierta: ${getAppNameFromPackage(packageName)} $previousTime")

                startTimer(packageName, previousTime) // Reanudar el contador para la app
                isAppForeground = true
                return
            }

            // Cambiar de aplicación (si el paquete cambia)
            if (packageName != lastAppPackage) {
                // Si una aplicación está en primer plano y es diferente de la última, cerramos la anterior
                if (lastAppPackage != null && isAppForeground) {
                    stopTimer(lastAppPackage!!)
                }

                // Verificamos que no sea una app del sistema
                if (isUserApp(packageName)) {
                    lastAppPackage = packageName

                    // Restaurar el tiempo de uso si ya existe
                    val previousTime = appUsageTimes[packageName] ?: 0
                    Log.d("AppMonitorService", "App abierta: ${getAppNameFromPackage(packageName)} $previousTime")

                    startTimer(packageName, previousTime) // Iniciar el contador para la nueva app en primer plano
                    isAppForeground = true
                }
            }
        }
    }
}


    override fun onInterrupt() {
        // Se invoca si el servicio necesita ser interrumpido
    }

    // Inicia el contador para la aplicación abierta
    private fun startTimer(packageName: String, initialTime: Int) {
        var secondsCounter = initialTime
        handler = Handler(Looper.getMainLooper())
        runnable = object : Runnable {
            override fun run() {
                val formattedTime = formatTime(secondsCounter)
                Log.d("AppMonitorService", "App abierta: ${getAppNameFromPackage(packageName)} $formattedTime")
                secondsCounter++
                appUsageTimes[packageName] = secondsCounter // Actualizamos el tiempo de uso en el HashMap
                handler?.postDelayed(this, 1000) // Ejecuta cada segundo
            }
        }
        handler?.post(runnable!!)
    }

    // Detener el contador y guardar el tiempo acumulado
    private fun stopTimer(packageName: String) {
        handler?.removeCallbacks(runnable!!)
        val totalTime = appUsageTimes[packageName] ?: 0
        val formattedTime = formatTime(totalTime)
        Log.d("AppMonitorService", "App cerrada: ${getAppNameFromPackage(packageName)} - tiempo de uso $formattedTime")
        isAppForeground = false
    }

    // Función para obtener el nombre de la aplicación desde el paquete
    private fun getAppNameFromPackage(packageName: String): String {
        return try {
            val packageManager = applicationContext.packageManager
            val appInfo = packageManager.getApplicationInfo(packageName, 0)
            packageManager.getApplicationLabel(appInfo).toString()
        } catch (e: Exception) {
            packageName // Si no se encuentra el nombre de la app, devuelve el paquete
        }
    }

    // Verificar si una aplicación es de usuario (no del sistema)
    private fun isUserApp(packageName: String): Boolean {
        return try {
            val packageManager = applicationContext.packageManager
            val appInfo = packageManager.getApplicationInfo(packageName, 0)
            (appInfo.flags and (android.content.pm.ApplicationInfo.FLAG_SYSTEM or android.content.pm.ApplicationInfo.FLAG_UPDATED_SYSTEM_APP)) == 0
        } catch (e: Exception) {
            false
        }
    }

    // Formatear tiempo en minutos y segundos
    private fun formatTime(seconds: Int): String {
        val minutes = seconds / 60
        val remainingSeconds = seconds % 60
        return String.format("%02d:%02d", minutes, remainingSeconds)
    }
}
