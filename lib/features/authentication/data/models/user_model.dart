import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String email,
    String? password,
  }) : super(id: id, email: email, password: password);

  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '', // Handle null email gracefully
    );
  }
}
