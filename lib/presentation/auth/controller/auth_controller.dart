import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/core/firebase_api/auth/login_user_firebase_auth.dart';
import 'package:wenia_assignment/core/firebase_api/auth/registet_user_firebase_auth.dart';
import 'package:wenia_assignment/core/firebase_api/firestore/fetch_user_firestore.dart';
import 'package:wenia_assignment/core/firebase_api/firestore/save_user_firestore.dart';
import 'package:wenia_assignment/core/utils/custom_navigator.dart';
import 'package:wenia_assignment/core/utils/user_preferens.dart';
import 'package:wenia_assignment/core/utils/utils.dart';
import 'package:wenia_assignment/data/datasource/models/user_model.dart';
import 'package:wenia_assignment/data/datasource/models/user_to_register_model.dart';
import 'package:wenia_assignment/presentation/home/home_screen.dart';

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

  final prefs = UserPreferences();

  RxBool isAdult = false.obs;
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un correo';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor ingrese un correo valido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese una contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres.';
    }
    // if (!RegExp(r'[A-Z]').hasMatch(value)) {
    //   return 'La contraseña debe contener al menos una letra mayúscula.';
    // }
    // if (!RegExp(r'[a-z]').hasMatch(value)) {
    //   return 'La contraseña debe contener al menos una letra minúscula.';
    // }
    // if (!RegExp(r'[0-9]').hasMatch(value)) {
    //   return 'La contraseña debe contener al menos un número.';
    // }
    // if (!RegExp(r'[!@#\$&*~%^()\-_=+[\]{};:\",<.>/?\\|]').hasMatch(value)) {
    //   return 'La contraseña debe contener al menos un carácter especial.';
    // }
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
    if (!(signUpEmailValidation == null &&
        signUpEmailController.text.isNotEmpty &&
        signUpPasswordValidation == null &&
        signUpPasswordController.text.isNotEmpty &&
        signUpConfirmPasswordValidation == null &&
        signUpConfirmPasswordController.text.isNotEmpty &&
        signUpNameValidation == null &&
        signUpNameController.text.isNotEmpty &&
        signUpDateofBirthValidation == null &&
        signUpDateofBirthController.text.isNotEmpty)) {
      print(signUpDateofBirthController);
      showErrorMsgSnackBar(
          'Please complete the form or verify that the entered data is correct.');
      return;
    }
    UserModel? userModel;
    await excecuteProcess(Get.context!, () async {
      User? user = await RegisterUserFirebaseAuth.call(
          email: signUpEmailController.text,
          pass: signUpPasswordController.text);
      if (user != null) {
        UserToRegisterModel userToRegister = UserToRegisterModel(
          user: user,
          name: signUpNameController.text,
          email: signUpEmailController.text,
          dateofBirth: signUpDateofBirthController.text,
          id: signUpIDController.text,
        );
        bool completeSaveData = await SaveUserFirestore.call(userToRegister);
        if (completeSaveData) {
          userModel = await FetchUserFirestore.call(user.uid);
          if (userModel != null) {
            prefs.saveUserData(userModel);
          }
        }
      }
    });
    if (userModel != null) {
      CustomNavigator.pushReplacement(Get.context!, HomeScreen());
    } else {
      showErrorMsgSnackBar('Please verify and try again');
    }
  }

  loginActions() async {
    if (!(loginEmailValidation == null &&
        loginEmailController.text.isNotEmpty &&
        loginPassValidation == null &&
        loginPassController.text.isNotEmpty)) {
      showErrorMsgSnackBar(
          'Please complete the form or verify that the entered data is correct.');
      return;
    }
    UserModel? userModel;
    await excecuteProcess(Get.context!, () async {
      User? user = await LoginUserFirebaseAuth.call(
          email: loginEmailController.text, pass: loginPassController.text);
      if (user != null) {
        userModel = await FetchUserFirestore.call(user.uid);
        if (userModel != null) {
          prefs.saveUserData(userModel);
        }
      }
    });
    if (userModel != null) {
      CustomNavigator.pushReplacement(Get.context!, HomeScreen());
    } else {
      showErrorMsgSnackBar('Please verify and try again');
    }
  }
}
