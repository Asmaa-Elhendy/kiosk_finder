import '../../../../core/error/exceptions.dart' as ex;
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> signUp(UserModel user);
  Future<UserModel> signIn(UserModel user);
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  UserRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> signUp(UserEntity user) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw FirebaseAuthException(
        code: e.toString(),
        message: "Error during Sign-Up",
      );
    }
  }

  @override
  Future<UserModel> signIn(UserModel user) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      throw FirebaseAuthException(
        code: e.toString(),
        message: "Error during Sign-In",
      );
    }
  }
}
