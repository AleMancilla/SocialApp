import 'package:flutter/material.dart';
import 'package:wenia_assignment/core/utils/custom_navigator.dart';
import 'package:wenia_assignment/core/utils/user_preferens.dart';
import 'package:wenia_assignment/presentation/auth/auth_home_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final prefs = UserPreferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                prefs.deleteUserData();
                CustomNavigator.pushReplacement(context, AuthHomeScreen());
                print('object');
              },
              child: Text('LogOut'),
            ),
          ],
        ),
      ),
    );
  }
}
