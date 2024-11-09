import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/presentation/auth/controller/auth_controller.dart';
import 'package:wenia_assignment/presentation/widgets/custom_text_file.dart';

class SignupFormSection extends StatefulWidget {
  const SignupFormSection({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  State<SignupFormSection> createState() => _SignupFormSectionState();
}

class _SignupFormSectionState extends State<SignupFormSection> {
  AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(color: Colors.white38),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFile(
                labelText: 'Correo',
                controller: controller.signUpEmailController,
                validation: controller.signUpEmailValidation,
                onChanged: (value) {
                  controller.signUpEmailValidation =
                      controller.validateEmail(value);
                  setState(() {});
                },
                keyboardType: TextInputType.emailAddress,
              ),
              CustomTextFile(
                labelText: 'Contraseña',
                isSecret: true,
                controller: controller.signUpPasswordController,
                validation: controller.signUpPasswordValidation,
                onChanged: (value) {
                  controller.signUpPasswordValidation =
                      controller.validatePassword(value);
                  setState(() {});
                },
                keyboardType: TextInputType.visiblePassword,
              ),
              CustomTextFile(
                labelText: 'Repita su contraseña',
                isSecret: true,
                controller: controller.signUpConfirmPasswordController,
                validation: controller.signUpConfirmPasswordValidation,
                onChanged: (value) {
                  controller.signUpConfirmPasswordValidation =
                      controller.validateConfirmPassword(value);
                  setState(() {});
                },
                keyboardType: TextInputType.visiblePassword,
              ),
              CustomTextFile(
                labelText: 'Nombre',
                controller: controller.signUpNameController,
                validation: controller.signUpNameValidation,
                onChanged: (value) {
                  controller.signUpNameValidation =
                      controller.validateEmptyController(value);
                  setState(() {});
                },
                keyboardType: TextInputType.name,
              ),
              // CustomTextFile(
              //   labelText: 'ID',
              //   controller: controller.signUpIDController,
              //   validation: controller.signUpIDValidation,
              //   onChanged: (value) {
              //     controller.signUpIDValidation =
              //         controller.validateEmptyController(value);
              //     setState(() {});
              //   },
              //   keyboardType: TextInputType.number,
              // ),
              CustomTextFile(
                labelText: 'Fecha de nacimiento',
                hintText: 'Elija una fecha',
                controller: controller.signUpDateofBirthController,
                validation: controller.signUpIDValidation,
                onChanged: (value) {
                  controller.signUpIDValidation =
                      controller.validateEmptyController(value);
                  setState(() {});
                },
                isCalendar: true,
              ),
              // Obx(() {
              //   return Row(
              //     children: <Widget>[
              //       Checkbox(
              //         value: controller.isAdult.value,
              //         onChanged: (value) {
              //           controller.isAdult.value = value!;
              //         },
              //       ),
              //       Text(
              //         "Declaro ser mayor de edad",
              //         style: TextStyle(color: Colors.green[900]),
              //       ),
              //     ],
              //   );
              // }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implementar la lógica de registro aquí
                  controller.signUpActions();
                },
                child: Text('Registrarse'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  widget._pageController.animateToPage(0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Text('Ya tienes una cuenta? inicia sesion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
