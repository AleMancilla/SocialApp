package com.alecodeando.weniatest

import android.content.Context
import android.database.sqlite.SQLiteOpenHelper
import android.content.ContentValues
import android.util.Log
import android.database.sqlite.SQLiteDatabase



class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, "shared_database_5.db", null, 5) {
    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL("""
            CREATE TABLE IF NOT EXISTS Users (
                user_id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                email TEXT NOT NULL,
                creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        db.execSQL("""
            CREATE TABLE IF NOT EXISTS AllowedApps (
                app_id INTEGER PRIMARY KEY AUTOINCREMENT,
                package_name TEXT NOT NULL,
                app_name TEXT NOT NULL,
                user_id INTEGER
            )
        """)
        db.execSQL("""
            CREATE TABLE IF NOT EXISTS UsageTime (
                usage_id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER,
                app_id INTEGER,
                date DATE NOT NULL,
                start_time TIMESTAMP NOT NULL,
                end_time TIMESTAMP,
                total_duration INTEGER
            )
        """)
        db.execSQL("""
            CREATE TABLE IF NOT EXISTS UsageLimits (
                limit_id INTEGER PRIMARY KEY AUTOINCREMENT,
                package_name TEXT NOT NULL,
                user_id INTEGER,
                app_id INTEGER,
                daily_limit INTEGER NOT NULL,
                notification_interval INTEGER NOT NULL
            )
        """)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        // Manejo de actualizaciones si es necesario
    }

    // Método para insertar un usuario
    fun insertUser(username: String, email: String): Long {
        val db = this.writableDatabase
        val values = ContentValues().apply{
            put("username", username)
            put("email", email)
        }
        return db.insert("Users", null, values)
    }

    // Método para insertar una aplicación permitida
    fun insertAllowedApp(packageName: String, appName: String, userId: Int?): Long {
        val db = this.writableDatabase
        val values = ContentValues().apply {
            put("package_name", packageName)
            put("app_name", appName)
            userId?.let { put("user_id", it) } // Agrega solo si no es nulo
        }
        return db.insert("AllowedApps", null, values)
    }

    fun deleteAllowedApp(packageName: String): Int {
        val db = this.writableDatabase
        return db.delete("AllowedApps", "package_name = ?", arrayOf(packageName))
    }
    fun deleteUsageLimits(packageName: String): Int {
        val db = this.writableDatabase
        return db.delete("UsageLimits", "package_name = ?", arrayOf(packageName))
    }

    // Método para insertar límites de uso
    fun insertUsageLimit(packageName:String,userId: Int, appId: Int, dailyLimit: Int, notificationInterval: Int): Long {
        val db = this.writableDatabase
            Log.e("==>> package_name <<======", "packageName: ${packageName}")
        val values = ContentValues().apply {
            put("package_name", packageName)
            put("user_id", userId)
            put("app_id", appId)
            put("daily_limit", dailyLimit)
            put("notification_interval", notificationInterval)
        }
        return db.insert("UsageLimits", null, values)
    }

    fun getUsers(): List<Map<String, Any>> {
        val db = this.readableDatabase
        val cursor = db.rawQuery("SELECT * FROM Users", null)
        val users = mutableListOf<Map<String, Any>>()

        if (cursor.moveToFirst()) {
            do {
                val user = mapOf(
                    "user_id" to cursor.getInt(cursor.getColumnIndex("user_id")),
                    "username" to cursor.getString(cursor.getColumnIndex("username")),
                    "email" to cursor.getString(cursor.getColumnIndex("email")),
                    "creation_date" to cursor.getString(cursor.getColumnIndex("creation_date"))
                )
                users.add(user)
            } while (cursor.moveToNext())
        }
        cursor.close()
        return users
    }
    fun getAllowedApps(): List<Map<String, Any>> {
        val db = this.readableDatabase
        val cursor = db.rawQuery("SELECT * FROM AllowedApps", null)
        val users = mutableListOf<Map<String, Any>>()

        if (cursor.moveToFirst()) {
            do {
                val user = mapOf(
                    "app_id" to cursor.getInt(cursor.getColumnIndex("app_id")),
                    "package_name" to cursor.getString(cursor.getColumnIndex("package_name")),
                    "app_name" to cursor.getString(cursor.getColumnIndex("app_name")),
                    "user_id" to cursor.getString(cursor.getColumnIndex("user_id")) // Cambiado "user_ide" a "user_id"
                )
                users.add(user)
            } while (cursor.moveToNext())
        }
        cursor.close()
        return users
    }
    fun getUsageLimits(): List<Map<String, Any>> {
        val db = this.readableDatabase
        val cursor = db.rawQuery("SELECT * FROM UsageLimits", null)
        val users = mutableListOf<Map<String, Any>>()

        // Imprimir todas las columnas en el cursor para ver sus nombres y asegurarse de que existen
        for (i in 0 until cursor.columnCount) {
            Log.e("==>> ColumnName", "Column $i: ${cursor.getColumnName(i)}")
        }

        if (cursor.moveToFirst()) {
            do {
                val user = mapOf(
                    "limit_id" to cursor.getInt(cursor.getColumnIndex("limit_id")),
                    "package_name" to cursor.getString(cursor.getColumnIndex("package_name")),
                    "user_id" to cursor.getInt(cursor.getColumnIndex("user_id")),
                    "app_id" to cursor.getString(cursor.getColumnIndex("app_id")),
                    "daily_limit" to cursor.getString(cursor.getColumnIndex("daily_limit")),
                    "notification_interval" to cursor.getString(cursor.getColumnIndex("notification_interval")) // Cambiado "user_ide" a "user_id"
                )
                users.add(user)
            } while (cursor.moveToNext())
        }
        cursor.close()
        return users
    }


    // Función para obtener todos los registros de "UsageLimit" en AppMonitorService
    fun getAllUsageLimits(): List<UsageLimit> {
        val usageLimits = mutableListOf<UsageLimit>()
        val db = this.readableDatabase
        val cursor = db.rawQuery("SELECT * FROM UsageLimits", null)
        
        if (cursor.moveToFirst()) {
            do {
                val limitId = cursor.getInt(cursor.getColumnIndexOrThrow("limit_id"))
                val packageName = cursor.getString(cursor.getColumnIndexOrThrow("package_name"))
                val limitTime = cursor.getInt(cursor.getColumnIndexOrThrow("daily_limit")) // Cambiado a daily_limit
                usageLimits.add(UsageLimit(limitId, packageName, limitTime))
            } while (cursor.moveToNext())
        }
        cursor.close()
        return usageLimits
    }


}

