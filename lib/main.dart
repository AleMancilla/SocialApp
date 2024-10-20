import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:overlay_pop_up/overlay_pop_up.dart';
import 'package:wenia_assignment/core/utils/user_preferens.dart';
import 'package:wenia_assignment/presentation/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPreferences();
  await prefs.initPreferences();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Social Stop',
      home: SplashScreen(),
      // theme: Themes().ligthMode,
    );
  }
}

///
/// the name is required to be `overlayPopUp` and has `@pragma("vm:entry-point")`
///
@pragma("vm:entry-point")
void overlayPopUp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OverlayWidget(),
  ));
}

class OverlayWidget extends StatefulWidget {
  @override
  _OverlayWidgetState createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  String _currentApp = "Unknown";
  Timer? _timer;
  AppUsage appUsage = AppUsage();

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndStartTracking();
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Verificar y solicitar permisos
  Future<void> _checkPermissionsAndStartTracking() async {
    _startAppUsageTracking();
  }

  //
  // Temporizador para actualizar periódicamente la app en primer plano
  void _startPeriodicUpdate() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      _startAppUsageTracking();
    });
  }

  // Obtener el nombre de la app en primer plano
  void _startAppUsageTracking() async {
    try {
      DateTime endTime = DateTime.now();
      DateTime startTime = endTime.subtract(Duration(minutes: 1));
      List<AppUsageInfo> infoList =
          await appUsage.getAppUsage(startTime, endTime);
      setState(() {
        _currentApp = infoList.last.appName;
        print(' ====== infoList.last.appName = ${infoList.last.appName}');
      });
    } on AppUsageException catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'App en primer plano: $_currentApp',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Colors.red[900],
              elevation: 12,
              onPressed: () async => await OverlayPopUp.closeOverlay(),
              child: Text('X',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
