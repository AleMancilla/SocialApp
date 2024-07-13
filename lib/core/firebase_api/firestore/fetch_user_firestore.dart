import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wenia_assignment/data/datasource/models/user_model.dart';

class FetchUserFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> call(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      throw Exception(
          "Error retrieving user data from Firestore: ${e.message}");
    } catch (e) {
      throw Exception(
          "Unknown error occurred while retrieving user data from Firestore");
    }
  }
}
