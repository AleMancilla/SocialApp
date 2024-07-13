import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wenia_assignment/data/datasource/models/user_model.dart';

class UpdateUserFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> call(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': user.name,
        'dateofBirth': user.dateOfBirth.toIso8601String(),
        'id': user.id,
        // Agrega aquí otros campos que desees actualizar
      });
      return true;
    } on FirebaseException catch (e) {
      throw Exception("Error updating user data in Firestore: ${e.message}");
    } catch (e) {
      print("Error desconocido: $e");
      throw Exception(
          "Unknown error occurred while updating user data in Firestore");
    }
  }
}
