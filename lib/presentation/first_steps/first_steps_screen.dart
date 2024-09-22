import 'package:flutter/material.dart';
import 'package:wenia_assignment/presentation/first_steps/steps/step_one.dart';

class FirstStepsScreen extends StatefulWidget {
  @override
  _FirstStepsScreenState createState() => _FirstStepsScreenState();
}

class _FirstStepsScreenState extends State<FirstStepsScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                StepOne(),
                Center(child: Text('Paso 2')),
                Center(child: Text('Paso 3')),
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
