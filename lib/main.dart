import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:wenia_assignment/core/theme/themes.dart';
import 'package:wenia_assignment/core/utils/user_preferens.dart';
import 'package:wenia_assignment/presentation/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPreferences();
  await prefs.initPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Assignment Wenia',
      home: SplashScreen(),
      theme: Themes().darkMode,
    );
  }
}
