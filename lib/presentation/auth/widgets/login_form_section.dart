import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:wenia_assignment/presentation/auth/controller/auth_controller.dart';
import 'package:wenia_assignment/presentation/widgets/custom_text_file.dart';

class LoginFormSection extends StatefulWidget {
  LoginFormSection({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection> {
  AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(color: Colors.white10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFile(
                labelText: 'Email',
                controller: controller.loginEmailController,
                validation: controller.loginEmailValidation,
                onChanged: (value) {
                  controller.loginEmailValidation =
                      controller.validateEmail(value);
                  setState(() {});
                },
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextFile(
                labelText: 'Password',
                isSecret: true,
                controller: controller.loginPassController,
                validation: controller.loginPassValidation,
                keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implementar la lógica de inicio de sesión aquí
                  controller.loginActions();
                },
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  widget._pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Text('Don\'t have an account? Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
