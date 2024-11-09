import 'package:flutter/services.dart';

class NativeCommunication {
  static const platform = MethodChannel('com.alecodeando/native');

  // Método para enviar datos a Kotlin
  Future<String> sendToKotlin(String message) async {
    try {
      final String result =
          await platform.invokeMethod('sendToKotlin', message);
      return result;
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  // Método para recibir datos desde Kotlin
  Future<void> receiveFromKotlin() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'receiveFromKotlin') {
        String message = call.arguments;
        // Haz algo con el mensaje recibido desde Kotlin
        print('Mensaje recibido de Kotlin: $message');
      }
    });
  }

  static const platformTime = MethodChannel('com.example.timeService');

  static Future<void> startService() async {
    try {
      await platformTime.invokeMethod('startService');
    } on PlatformException catch (e) {
      print("Failed to start service: '${e.message}'");
    }
  }
}
