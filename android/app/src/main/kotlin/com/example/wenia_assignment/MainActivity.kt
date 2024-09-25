package com.alecodeando.weniatest

import android.content.pm.PackageManager
import android.graphics.drawable.BitmapDrawable
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.app/icons"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAppIcon") {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    result.success(getAppIcon(packageName))
                } else {
                    result.error("UNAVAILABLE", "Package name not provided", null)
                }
            }
        }
    }

    private fun getAppIcon(packageName: String): ByteArray? {
        return try {
            val pm: PackageManager = packageManager
            val icon = pm.getApplicationIcon(packageName)
            val bitmap = (icon as BitmapDrawable).bitmap
            val stream = ByteArrayOutputStream()
            bitmap.compress(android.graphics.Bitmap.CompressFormat.PNG, 100, stream)
            stream.toByteArray()
        } catch (e: PackageManager.NameNotFoundException) {
            null
        }
    }
}