import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wenia_assignment/data/datasource/models/user_model.dart';

class FetchUserFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> call(String uid) async {
    print(' =========== > uid === $uid');
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      print("Error de Firebase: ${e.message}");
      throw Exception(
          "Error al recuperar los datos del usuario de Firestore: ${e.message}");
    } catch (e) {
      print("Error desconocido: $e");
      throw Exception(
          "Error desconocido al recuperar los datos del usuario de Firestore");
    }
  }
}
