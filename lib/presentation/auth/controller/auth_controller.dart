import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:wenia_assignment/core/firebase_api/login_user_firebase_auth.dart';
import 'package:wenia_assignment/core/firebase_api/registet_user_firebase_auth.dart';
import 'package:wenia_assignment/core/utils/utils.dart';

class AuthController extends GetxController {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPassController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController signUpConfirmPasswordController =
      TextEditingController();
  TextEditingController signUpNameController = TextEditingController();
  TextEditingController signUpIDController = TextEditingController();
  TextEditingController signUpDateofBirthController = TextEditingController();

  String? loginEmailValidation;
  String? loginPassValidation;
  String? signUpEmailValidation;
  String? signUpPasswordValidation;
  String? signUpConfirmPasswordValidation;
  String? signUpNameValidation;
  String? signUpIDValidation;
  String? signUpDateofBirthValidation;

  RxBool isAdult = false.obs;
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#\$&*~%^()\-_=+[\]{};:\",<.>/?\\|]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (signUpPasswordController.text != signUpConfirmPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateEmptyController(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required field';
    }
    return null;
  }

  signUpActions() async {
    User? user;
    await excecuteProcess(Get.context!, () async {
      user = await RegisterUserFirebaseAuth.call(
          email: signUpEmailController.text,
          pass: signUpPasswordController.text);
    });
    if (user != null) {
      print('registro exitoso');
    } else {
      print('algo paso');
    }
  }

  loginActions() async {
    User? user;
    await excecuteProcess(Get.context!, () async {
      user = await LoginUserFirebaseAuth.call(
          email: loginEmailController.text, pass: loginPassController.text);
    });
    if (user != null) {
      print('login exitoso');
    } else {
      print('algo paso');
    }
  }
}
