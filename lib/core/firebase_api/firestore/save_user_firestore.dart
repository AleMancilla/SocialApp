import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wenia_assignment/data/datasource/models/user_to_register_model.dart';

class SaveUserFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> call(UserToRegisterModel user) async {
    try {
      // Guardar datos en Firestore
      await _firestore.collection('users').doc(user.user.uid).set({
        'email': user.email,
        'uid': user.user.uid,
        'name': user.name,
        'id': user.id,
        'dateofBirth': user.dateofBirth,
      });
      return true;
    } on FirebaseException catch (e) {
      // Manejo de errores específicos de Firebase
      throw Exception("Error saving user data to Firestore: ${e.message}");
    } catch (e) {
      // Manejo de otros errores
      throw Exception(
          "Unknown error occurred while saving user data to Firestore");
    }
  }
}
