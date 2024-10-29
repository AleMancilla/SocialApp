import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/core/database/databaseservice.dart';
import 'package:wenia_assignment/core/utils/custom_navigator.dart';
import 'package:wenia_assignment/presentation/auth/auth_home_screen.dart';
import 'package:wenia_assignment/presentation/first_steps/steps/step_cero.dart';
import 'package:wenia_assignment/presentation/first_steps/steps/step_four.dart';
import 'package:wenia_assignment/presentation/first_steps/steps/step_one.dart';
import 'package:wenia_assignment/presentation/first_steps/steps/step_tree.dart';
import 'package:wenia_assignment/presentation/first_steps/steps/step_two.dart';
import 'package:wenia_assignment/presentation/first_steps/steps/steps_controller.dart';

class FirstStepsScreen extends StatefulWidget {
  @override
  _FirstStepsScreenState createState() => _FirstStepsScreenState();
}

class _FirstStepsScreenState extends State<FirstStepsScreen> {
  final PageController _pageController = PageController();
  StepsController controller = Get.put(StepsController());
  int _currentStep = 0;
  final int _totalSteps = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            label: Text('insertar'),
            onPressed: () async {
              print(' ------ tap');
              // final users = await DatabaseService.getUsers();

              // await DatabaseService.insertUser(
              //     'JohnDoe', 'john.doe@example.com');

              // await DatabaseService.insertAllowedApp(
              //     'com.whatsapp', 'WhatsApp', null);

              await DatabaseService.insertUsageLimit(1, 1, 120,
                  10); // Ejemplo: usuario ID 1, app ID 1, límite diario 120 minutos, intervalo de notificación 10 minutos
            },
            // child: Text('Consulta'),
          ),
          FloatingActionButton.extended(
            label: Text('Consulta'),
            onPressed: () async {
              print(' ------ tap');
              // final users = await DatabaseService.getUsers();
              // final response = await DatabaseService.getAllowedApps();
              final response = await DatabaseService.getUsageLimits();
              print(response);
            },
            // child: Text('Consulta'),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text('Social Stop'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                StepCero(),
                StepOne(),
                StepTwo(),
                StepTree(),
                StepFour(),
                Center(child: Text('Bienvenido')),
              ],
            ),
          ),
          _buildStepIndicator(),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: const Text(
              'SIGUIENTE',
              style: TextStyle(
                color: Colors.transparent,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < _totalSteps; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor:
                          i == _currentStep ? Colors.blue : Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              print(' ---- _pageController.page ----- ${_pageController.page}');
              if (_pageController.page == 4) {
                CustomNavigator.push(context, AuthHomeScreen());
                return;
              }
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: const Text(
                'SIGUIENTE',
                style: TextStyle(
                  color: Colors.cyan,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
