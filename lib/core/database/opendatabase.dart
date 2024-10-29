import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initOpenDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'shared_database_2.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS Users (
          user_id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          email TEXT NOT NULL,
          creation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS AllowedApps (
          app_id INTEGER PRIMARY KEY AUTOINCREMENT,
          package_name TEXT NOT NULL,
          app_name TEXT NOT NULL,
          user_id INTEGER
        )
      ''');
      await db.execute('''
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
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS UsageLimits (
          limit_id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          app_id INTEGER,
          daily_limit INTEGER NOT NULL,
          notification_interval INTEGER NOT NULL,
          FOREIGN KEY (app_id) REFERENCES AllowedApps(app_id) ON DELETE CASCADE
        )
      ''');
    },
  );
}
