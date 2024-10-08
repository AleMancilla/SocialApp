package com.alecodeando.weniatest
import android.accessibilityservice.AccessibilityService
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.os.Handler
import android.os.Looper

class AppMonitorService : AccessibilityService() {

    private var lastAppPackage: String? = null
    private var secondsCounter: Int = 0
    private var handler: Handler? = null
    private var runnable: Runnable? = null

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        if (event.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString()

            if (packageName != null && packageName != lastAppPackage) {
                // Si hay una app previa abierta, la consideramos cerrada
                if (lastAppPackage != null) {
                    stopTimer() // Detenemos el contador para la app anterior
                }

                // Verificamos si la app no es una app del sistema
                if (isUserApp(packageName)) {
                    lastAppPackage = packageName
                    startTimer() // Iniciamos el contador para la nueva app abierta
                    Log.d("AppMonitorService", "App abierta: ${getAppNameFromPackage(packageName)} ($packageName)")
                }
            }
        }
    }

    override fun onInterrupt() {
        // Se invoca si el servicio necesita ser interrumpido
    }

    // Inicia el contador de tiempo para la aplicación abierta
    private fun startTimer() {
        secondsCounter = 0
        handler = Handler(Looper.getMainLooper())
        runnable = object : Runnable {
            override fun run() {
                val formattedTime = formatTime(secondsCounter)
                Log.d("AppMonitorService", "App abierta: ${getAppNameFromPackage(lastAppPackage!!)} $formattedTime")
                secondsCounter++
                handler?.postDelayed(this, 1000) // Ejecuta cada segundo
            }
        }
        handler?.post(runnable!!)
    }

    // Detiene el contador de tiempo y muestra el tiempo total de uso
    private fun stopTimer() {
        handler?.removeCallbacks(runnable!!)
        val formattedTime = formatTime(secondsCounter)
        Log.d("AppMonitorService", "App cerrada: ${getAppNameFromPackage(lastAppPackage!!)} - tiempo de uso $formattedTime")
    }

    // Función para obtener el nombre de la aplicación desde el nombre del paquete
    private fun getAppNameFromPackage(packageName: String): String {
        return try {
            val packageManager = applicationContext.packageManager
            val appInfo = packageManager.getApplicationInfo(packageName, 0)
            packageManager.getApplicationLabel(appInfo).toString()
        } catch (e: Exception) {
            packageName // Si no se encuentra el nombre de la app, devuelve el nombre del paquete
        }
    }

    // Función para verificar si una aplicación es de usuario (no del sistema)
    private fun isUserApp(packageName: String): Boolean {
        return try {
            val packageManager = applicationContext.packageManager
            val appInfo = packageManager.getApplicationInfo(packageName, 0)
            (appInfo.flags and (android.content.pm.ApplicationInfo.FLAG_SYSTEM or android.content.pm.ApplicationInfo.FLAG_UPDATED_SYSTEM_APP)) == 0
        } catch (e: Exception) {
            false
        }
    }

    // Función para formatear el tiempo en minutos y segundos
    private fun formatTime(seconds: Int): String {
        val minutes = seconds / 60
        val remainingSeconds = seconds % 60
        return String.format("%02d:%02d", minutes, remainingSeconds)
    }
}
