import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeCommunicationScreen extends StatefulWidget {
  @override
  _NativeCommunicationScreenState createState() =>
      _NativeCommunicationScreenState();
}

class _NativeCommunicationScreenState extends State<NativeCommunicationScreen> {
  static const platform = MethodChannel('com.alecodeando/native');
  static const platformTime = MethodChannel('com.example.timeService');
  String _messageFromKotlin = "Esperando mensaje desde Kotlin...";

  @override
  void initState() {
    super.initState();
    listenForKotlinMessages(); // Empezamos a escuchar mensajes de Kotlin
  }

  // Método para enviar mensaje a Kotlin
  Future<void> sendMessageToKotlin() async {
    try {
      String response =
          await platform.invokeMethod('sendToKotlin', "Hola desde Flutter");
      print("Respuesta desde Kotlin: $response");
    } catch (e) {
      print("Error al enviar mensaje a Kotlin: ${e.toString()}");
    }
  }

  // Método para enviar mensaje a Kotlin
  Future<void> sendMessageToKotlinStartTime() async {
    try {
      String response =
          await platformTime.invokeMethod('startService', "Hola desde Flutter");
      print("Respuesta desde Kotlin: $response");
    } catch (e) {
      print("Error al enviar mensaje a Kotlin: ${e.toString()}");
    }
  }

  // Método para escuchar mensajes desde Kotlin
  Future<void> listenForKotlinMessages() async {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'receiveFromKotlin') {
        String message = call.arguments;
        setState(() {
          _messageFromKotlin = message;
        });
        print('Mensaje recibido de Kotlin: $message');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter - Kotlin Communication'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        sendMessageToKotlinStartTime();
      }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Mensaje desde Kotlin:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _messageFromKotlin,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: sendMessageToKotlin,
              child: Text('Enviar mensaje a Kotlin'),
            ),
          ],
        ),
      ),
    );
  }
}
