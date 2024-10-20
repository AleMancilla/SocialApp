package com.alecodeando.weniatest

import android.app.Service
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.util.Log
import java.util.concurrent.ConcurrentHashMap

class AppUsageService : Service() {

    private val appUsageMap = ConcurrentHashMap<String, Long>()
    private val appStartTimeMap = ConcurrentHashMap<String, Long>()

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Thread {
            monitorAppUsage()
        }.start()
        return START_STICKY
    }

    private fun monitorAppUsage() {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        var startTime = endTime - 1000

        while (true) {
            val usageEvents = usageStatsManager.queryEvents(startTime, endTime)
            val event = UsageEvents.Event()

            while (usageEvents.hasNextEvent()) {
                usageEvents.getNextEvent(event)
                handleEvent(event)
            }
            startTime = endTime
            Thread.sleep(1000)
        }
    }

    private fun handleEvent(event: UsageEvents.Event) {
        val packageName = event.packageName
        when (event.eventType) {
            UsageEvents.Event.MOVE_TO_FOREGROUND -> {
                appStartTimeMap[packageName] = System.currentTimeMillis()
                Log.d("AppUsageService", "App $packageName moved to foreground")
            }
            UsageEvents.Event.MOVE_TO_BACKGROUND -> {
                val startTime = appStartTimeMap[packageName] ?: return
                val usageTime = System.currentTimeMillis() - startTime
                appUsageMap[packageName] = appUsageMap.getOrDefault(packageName, 0L) + usageTime
                appStartTimeMap.remove(packageName)
                Log.d("AppUsageService", "App $packageName moved to background, used for $usageTime ms")
            }
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    fun getAppUsageTime(packageName: String): Long {
        return appUsageMap[packageName] ?: 0L
    }
}
