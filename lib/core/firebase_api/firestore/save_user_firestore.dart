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
      print("Datos del usuario guardados correctamente.");
      return true;
    } on FirebaseException catch (e) {
      // Manejo de errores específicos de Firebase
      print("Error de Firebase: ${e.message}");
      throw Exception(
          "Error al guardar los datos del usuario en Firestore: ${e.message}");
    } catch (e) {
      // Manejo de otros errores
      print("Error desconocido: $e");
      throw Exception(
          "Error desconocido al guardar los datos del usuario en Firestore");
    }
  }
}
