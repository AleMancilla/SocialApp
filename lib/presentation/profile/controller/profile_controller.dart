import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/core/firebase_api/firestore/fetch_user_firestore.dart';
import 'package:wenia_assignment/core/firebase_api/firestore/update_user_firestore.dart';
import 'package:wenia_assignment/core/utils/user_preferens.dart';
import 'package:wenia_assignment/core/utils/utils.dart';
import 'package:wenia_assignment/data/datasource/models/user_model.dart';

class ProfileController extends GetxController {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController idController = TextEditingController();
  late TextEditingController dateOfBirthController = TextEditingController();

  final prefs = UserPreferences();

  @override
  void onInit() {
    nameController.text = prefs.username ?? '';
    idController.text = prefs.userid ?? '';
    dateOfBirthController.text = prefs.userdateOfBirth ?? '';
    super.onInit();
  }

  Future<void> updateProfile() async {
    try {
      UserModel updatedUser = UserModel(
        uid: prefs.useruid ?? '',
        email: prefs.useremail ?? '',
        name: nameController.text,
        id: idController.text,
        dateOfBirth: DateTime.parse(dateOfBirthController.text),
      );
      await excecuteProcess(Get.context!, () async {
        await UpdateUserFirestore.call(updatedUser);
        await refreshData();
      });

      showConfirmMsgSnackBar('Profile updated successfully');
    } catch (e) {
      showErrorMsgSnackBar('Error updating profile: $e');
    }
  }

  refreshData() async {
    UserModel? userModel = await FetchUserFirestore.call(prefs.useruid!);
    if (userModel != null) {
      prefs.saveUserData(userModel);
    }
  }
}
