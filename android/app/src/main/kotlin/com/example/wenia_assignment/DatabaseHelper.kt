package com.alecodeando.weniatest

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.content.ContentValues
import android.util.Log


class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, "shared_database_2.db", null, 1) {
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
                total_duration INTEGER,
                FOREIGN KEY (app_id) REFERENCES AllowedApps(app_id) ON DELETE CASCADE
            )
        """)
        db.execSQL("""
            CREATE TABLE IF NOT EXISTS UsageLimits (
                limit_id INTEGER PRIMARY KEY AUTOINCREMENT,
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

    // Método para insertar límites de uso
    fun insertUsageLimit(userId: Int, appId: Int, dailyLimit: Int, notificationInterval: Int): Long {
        val db = this.writableDatabase
        val values = ContentValues().apply {
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

        if (cursor.moveToFirst()) {
            do {
                val user = mapOf(
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

}
