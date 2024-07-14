import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateUserFavoritesFirestore {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> call(String uuid, List<String> listFavorite) async {
    try {
      await _firestore.collection('users').doc(uuid).update({
        'favoriteCoinList': listFavorite,
        // Agrega aquí otros campos que desees actualizar
      });
      return true;
    } on FirebaseException catch (e) {
      throw Exception("Error updating user data in Firestore: ${e.message}");
    } catch (e) {
      throw Exception(
          "Unknown error occurred while updating user data in Firestore");
    }
  }
}
