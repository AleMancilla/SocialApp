package com.alecodeando.weniatest

import android.content.pm.PackageManager
import android.graphics.drawable.BitmapDrawable
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.net.Uri

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.alecodeando/native"
    private val CHANNELTIMESERVICE = "com.example.timeService"


    override fun onResume() {
        super.onResume()
        startSendingMessagesToFlutter() // Iniciar envío de mensajes después de reanudar la actividad
    }

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendToKotlin") {
                val message = call.arguments as String
                println("Mensaje recibido de Flutter: $message")

                // Enviar respuesta de vuelta a Flutter
                result.success("Mensaje recibido correctamente en Kotlin")
            } else {
                result.notImplemented()
            }
        }


        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNELTIMESERVICE).setMethodCallHandler { call, result ->
            if (call.method == "startService") {
                // startBackgroundTimeService(this)
                openAccessibilitySettings(this)
                result.success("Service started")
            } else {
                result.notImplemented()
            }
        }
    }

    // Método para enviar datos desde Kotlin a Flutter
    fun sendToFlutter(message: String) {
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
            .invokeMethod("receiveFromKotlin", message)
    }

    // Llamar a sendToFlutter automáticamente
    fun startSendingMessagesToFlutter() {
        Handler(Looper.getMainLooper()).postDelayed({
            sendToFlutter("Mensaje enviado desde Kotlin después de 5 segundos")
        }, 5000) // Enviar mensaje después de 5 segundos
    }



    fun startBackgroundTimeService(context: Context) {
        val intent = Intent(context, TimeService::class.java)
        context.startService(intent)
    }

    fun openAccessibilitySettings(context: Context) {
        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }
    
}
