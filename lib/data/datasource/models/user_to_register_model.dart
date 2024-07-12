import 'package:firebase_auth/firebase_auth.dart';

class UserToRegisterModel {
  User user;
  String name;
  String email;
  String id;
  String dateofBirth;

  UserToRegisterModel({
    required this.user,
    required this.name,
    required this.email,
    required this.id,
    required this.dateofBirth,
  });
}
