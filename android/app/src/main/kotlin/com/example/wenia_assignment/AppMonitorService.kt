package com.alecodeando.weniatest

import android.app.usage.UsageStatsManager
import android.app.usage.UsageEvents
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.app.Service
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import java.util.Calendar

import android.graphics.PixelFormat
import android.os.Build
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.Button

class AppMonitorService : Service() {

    private val handler = Handler(Looper.getMainLooper())
    private var monitorRunnable: Runnable? = null
    private lateinit var usageStatsManager: UsageStatsManager
    private var lastAppPackage: String? = null
    private var appTimerRunnable: Runnable? = null
    private var totalUsageTime = 0 // Tiempo de uso total en segundos
    private var isScreenOn = true // Estado de la pantalla
    private var hasShownLimitPopup = false // Variable para controlar si el popup ya fue mostrado
    private val usageLimitInSeconds = 15 * 60 // 15 minutos

    private var remainingExtraTime = 0 // Tiempo extra restante en segundos
    private var extraTimePerApp = mutableMapOf<String, Int>() // Mapa para el tiempo extra por aplicación



    // Lista de paquetes permitidos
    private val allowedPackages = listOf(
        "com.whatsapp",       // WhatsApp
        "com.facebook.katana", // Facebook
        "com.instagram.android", // Instagram
        // Agrega más paquetes según lo necesites
    )

    // BroadcastReceiver para manejar el estado de la pantalla
    private val screenStateReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            when (intent?.action) {
                Intent.ACTION_SCREEN_OFF -> {
                    isScreenOn = false
                    stopTracking(lastAppPackage) // Pausar cuando la pantalla se apaga
                    Log.d("AppMonitorService", "Pantalla apagada")
                }
                Intent.ACTION_SCREEN_ON -> {
                    isScreenOn = true
                    lastAppPackage?.let { startTracking(it) } // Reanudar cuando la pantalla se enciende
                    Log.d("AppMonitorService", "Pantalla encendida")
                }
            }
        }
    }

    override fun onCreate() {
        super.onCreate()
        usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

        // Registrar el BroadcastReceiver para los eventos de pantalla
        val filter = IntentFilter(Intent.ACTION_SCREEN_ON).apply {
            addAction(Intent.ACTION_SCREEN_OFF)
        }
        registerReceiver(screenStateReceiver, filter)

        startMonitoring()
    }

    private fun startMonitoring() {
        monitorRunnable = object : Runnable {
            override fun run() {
                if (isScreenOn) {
                    checkForegroundApp()
                }
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

            if (allowedPackages.contains(currentApp)) {
                if (currentApp != lastAppPackage) {
                    lastAppPackage?.let { stopTracking(it) }
                    startTracking(currentApp)
                    lastAppPackage = currentApp
                }
            } else {
                // Si el paquete no está permitido, detener el seguimiento
                lastAppPackage?.let { stopTracking(it) }
                lastAppPackage = null // Restablecer el paquete actual
            }
        }
    }

    
    private fun startTracking(packageName: String) {
        totalUsageTime = getAppUsageTime(packageName)
        Log.d("AppMonitorService", "App abierta: $packageName - Tiempo acumulado: ${formatTime(totalUsageTime)}")

        appTimerRunnable = object : Runnable {
            override fun run() {
                totalUsageTime++
                val formattedTime = formatTime(totalUsageTime)
                Log.d("AppMonitorService", "App en uso: $packageName - Tiempo: $formattedTime")

                val intent = Intent(this@AppMonitorService, FloatingWidgetService::class.java)
                intent.putExtra("usage_time", formattedTime)
                intent.putExtra("usage_seconds", totalUsageTime)
                startService(intent)

                // Obtener el tiempo extra para la aplicación actual
                val extraTime = extraTimePerApp[packageName] ?: 0

                // Verificar si ya se ha excedido el límite y si aún queda tiempo adicional
                if (totalUsageTime >= usageLimitInSeconds && extraTime <= 0 && !hasShownLimitPopup) {
                    showUsageLimitPopup(packageName) // Mostrar popup si se excede el tiempo límite
                    hasShownLimitPopup = true
                } else if (extraTime > 0) {
                    // Si hay tiempo extra, reducirlo y continuar
                    extraTimePerApp[packageName] = extraTime - 1
                    Log.d("AppMonitorService", "Tiempo extra restante para $packageName: ${extraTimePerApp[packageName]}")
                }

                handler.postDelayed(this, 1000) // Incrementa cada segundo
            }
        }
        appTimerRunnable?.let { handler.post(it) }
    }

    private fun stopTracking(packageName: String?) {
        appTimerRunnable?.let { handler.removeCallbacks(it) }
        if (packageName != null) {
            val totalUsageTimeNow = getAppUsageTime(packageName)
            Log.d("AppMonitorService", "App cerrada: $packageName - Tiempo total: ${formatTime(totalUsageTimeNow)}")

            val intent = Intent(this@AppMonitorService, FloatingWidgetService::class.java)
            intent.action = "CLOSE_WIDGET"
            startService(intent)

            // Mantener el tiempo extra si la aplicación se pasa a segundo plano
            // No eliminamos el tiempo extra aquí, para que no se pierda cuando regrese al primer plano
        }
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

        // Desregistrar el BroadcastReceiver
        unregisterReceiver(screenStateReceiver)
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    // Función para mostrar el popup cuando el tiempo de uso es excedido
    private fun showUsageLimitPopup(packageName: String) {
        val inflater = getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val popupView = inflater.inflate(R.layout.usage_limit_popup, null)

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )
        params.gravity = Gravity.CENTER

        val windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        windowManager.addView(popupView, params)

        val closeButton = popupView.findViewById<Button>(R.id.close_popup_button)
        closeButton.setOnClickListener {
            windowManager.removeView(popupView)
        }

        val oneMoreMinuteButton = popupView.findViewById<Button>(R.id.one_more_minute_button)
        oneMoreMinuteButton.setOnClickListener {
            extendUsageTime(packageName) // Extender el tiempo de uso solo para la app actual
            windowManager.removeView(popupView) // Cerrar el popup
        }
    }
     // Método para extender el tiempo de uso en 1 minuto
    private fun extendUsageTime(packageName: String) {
        val currentExtraTime = extraTimePerApp[packageName] ?: 0
        extraTimePerApp[packageName] = currentExtraTime + 60 // Añadir 60 segundos al tiempo extra de la app actual
        hasShownLimitPopup = false // Permitir que el popup se muestre nuevamente solo si se agota el tiempo extra
        Log.d("AppMonitorService", "Se ha añadido 1 minuto extra a $packageName")
    }

}
