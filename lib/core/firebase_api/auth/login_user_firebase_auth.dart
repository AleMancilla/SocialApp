import 'package:firebase_auth/firebase_auth.dart';

class LoginUserFirebaseAuth {
  static Future<User?> call(
      {required String email, required String pass}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Manejar errores de FirebaseAuth
      throw ("Error: $e");
    } catch (e) {
      // Manejar otros errores
      throw ("Error: $e");
    }
  }
}
