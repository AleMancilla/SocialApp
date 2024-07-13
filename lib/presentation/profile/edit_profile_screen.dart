import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wenia_assignment/presentation/profile/controller/profile_controller.dart';
import 'package:wenia_assignment/presentation/widgets/custom_text_file.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFile(
              controller: controller.nameController,
              labelText: 'Name',
            ),
            CustomTextFile(
              controller: controller.idController,
              labelText: 'ID',
            ),
            SizedBox(height: 16),
            CustomTextFile(
              controller: controller.dateOfBirthController,
              labelText: 'Date of Birth',
              isCalendar: true,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: controller.updateProfile,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
