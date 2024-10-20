package com.alecodeando.weniatest

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.TextView

import android.graphics.PixelFormat
import android.view.Gravity

import android.view.MotionEvent


class FloatingWidgetService : Service() {


    private lateinit var floatingView: View
    private lateinit var windowManager: WindowManager
    private val handler = Handler()

    private var initialX = 0
    private var initialY = 0
    private var initialTouchX = 0f
    private var initialTouchY = 0f

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        intent?.let {
            val usageTime = it.getStringExtra("usage_time")
            usageTime?.let { time -> updateUsageTime(time) }
        }
        return START_STICKY
    }


    override fun onCreate() {
        super.onCreate()

        // Inflar el diseño del widget flotante
        floatingView = LayoutInflater.from(this).inflate(R.layout.floating_widget_layout, null)

        // Configurar parámetros de la ventana
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY else WindowManager.LayoutParams.TYPE_PHONE, // Usa TYPE_APPLICATION_OVERLAY para Android O y superiores
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            PixelFormat.TRANSLUCENT
        )

        // Establecer la posición del widget flotante
        params.gravity = Gravity.TOP or Gravity.START
        params.x = 0
        params.y = 100 // Cambia la posición Y según sea necesario

        // Agregar la vista al WindowManager
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
        windowManager.addView(floatingView, params)

        // Hacer que el widget flotante sea arrastrable
        floatingView.setOnTouchListener { v, event ->
            when (event.action) {
                MotionEvent.ACTION_DOWN -> {
                    initialX = params.x
                    initialY = params.y
                    initialTouchX = event.rawX
                    initialTouchY = event.rawY
                    true
                }
                MotionEvent.ACTION_MOVE -> {
                    params.x = initialX + (event.rawX - initialTouchX).toInt()
                    params.y = initialY + (event.rawY - initialTouchY).toInt()
                    windowManager.updateViewLayout(floatingView, params)
                    true
                }
                else -> false
            }
        }
    }

    fun updateUsageTime(usageTime: String) {
        val usageTextView = floatingView.findViewById<TextView>(R.id.usage_time_text_view)
        usageTextView.text = usageTime
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::floatingView.isInitialized) {
            windowManager.removeView(floatingView)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
