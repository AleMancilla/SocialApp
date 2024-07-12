import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String id;
  final DateTime dateOfBirth;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.id,
    required this.dateOfBirth,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      id: data['id'],
      dateOfBirth: DateTime.parse(data['dateofBirth']),
    );
  }
}
