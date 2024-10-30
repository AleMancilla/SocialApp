import 'package:flutter/services.dart';

class DatabaseService {
  static const MethodChannel _channel =
      MethodChannel('com.example.wenia_assignment/database');

  Future<void> _refreshUsageLimits() async {
    try {
      await _channel.invokeMethod('refreshUsageLimits');
      print("Usage limits refreshed successfully");
    } on PlatformException catch (e) {
      print("Failed to refresh usage limits: '${e.message}'.");
    }
  }

  static Future<void> initDatabase() async {
    try {
      await _channel.invokeMethod('initDatabase');
      print('Base de datos inicializada en Kotlin');
    } catch (e) {
      print("Error inicializando la base de datos: $e");
    }
  }

  static Future<void> insertUser(String username, String email) async {
    try {
      final result = await _channel.invokeMethod('insertUser', {
        'username': username,
        'email': email,
      });
      print(result); // Muestra el ID del nuevo usuario o mensaje de error
    } catch (e) {
      print("Error al insertar usuario: $e");
    }
  }

  static Future<void> insertAllowedApp(
      String packageName, String appName, int? userId) async {
    try {
      final result = await _channel.invokeMethod('insertAllowedApp', {
        'packageName': packageName,
        'appName': appName,
        'userId': userId,
      });
      print(
          result); // Muestra el ID de la aplicación permitida o mensaje de error
    } catch (e) {
      print("Error al insertar aplicación permitida: $e");
    }
  }

  static Future<void> deleteAllowedApp(String packageName) async {
    try {
      final result = await _channel.invokeMethod('deleteAllowedApp', {
        'packageName': packageName,
      });
      print(result); // Muestra confirmación de eliminación o mensaje de error
    } catch (e) {
      print("Error al eliminar la aplicación permitida: $e");
    }
  }

  static Future<void> deleteUsageLimits(String packageName) async {
    try {
      final result = await _channel.invokeMethod('deleteUsageLimits', {
        'packageName': packageName,
      });
      print(result); // Muestra confirmación de eliminación o mensaje de error
    } catch (e) {
      print("Error al eliminar la aplicación permitida: $e");
    }
  }

  static Future<void> insertUsageLimit(int userId, int appId, int dailyLimit,
      int notificationInterval, String package) async {
    try {
      final result = await _channel.invokeMethod('insertUsageLimit', {
        'packageName': package,
        'userId': userId,
        'appId': appId,
        'dailyLimit': dailyLimit,
        'notificationInterval': notificationInterval
      });
      print(result); // Muestra el ID del límite de uso o mensaje de error
    } catch (e) {
      print("Error al insertar límite de uso: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final List<dynamic> users = await _channel.invokeMethod('getUsers');
      return users
          .map((user) => Map<String, dynamic>.from(user as Map))
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return []; // Retorna una lista vacía en caso de error
    }
  }

  static Future<List<Map<String, dynamic>>> getAllowedApps() async {
    try {
      final List<dynamic> users = await _channel.invokeMethod('getAllowedApps');
      return users
          .map((user) => Map<String, dynamic>.from(user as Map))
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return []; // Retorna una lista vacía en caso de error
    }
  }

  static Future<List<Map<String, dynamic>>> getUsageLimits() async {
    try {
      final List<dynamic> users = await _channel.invokeMethod('getUsageLimits');
      return users
          .map((user) => Map<String, dynamic>.from(user as Map))
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return []; // Retorna una lista vacía en caso de error
    }
  }
}
