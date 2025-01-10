import '../../../../core/error/exceptions.dart' as ex;
import '../../domain/entities/user.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signUp(UserModel user);
  Future<UserModel> signIn(UserModel user);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserModel> signUp(UserEntity user) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      print('e is $e');
      if (e is FirebaseAuthException) {
        // Firebase Authentication error
        if (e.code == 'email-already-in-use') {
          throw ex.EmailAlreadyInUseException();
        } else if (e.code == 'weak-password') {
          throw ex.WeakPasswordException();
        } else if (e.code == 'invalid-email') {
          throw ex.InvalidEmailException();
        }
      }
      print(e);
      throw FirebaseAuthException(
        code: e.toString(),
        message: "Error during Sign-up",
      );
    }
  }

  @override
  Future<UserModel> signIn(UserModel user) async {
    try {
      print(user.email);
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );
      print(UserModel.fromFirebaseUser(userCredential.user!));
      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      print('e is $e');
      if (e is FirebaseAuthException) {
        // Firebase Authentication error
        if (e.code == 'user-not-found') {
          throw ex.UserNotFoundException();
        } else if (e.code == 'wrong-password') {
          throw ex.WrongPasswordException();
        } else if (e.code == 'invalid-email') {
          throw ex.InvalidEmailException();
        }
      }
      print(e);
      throw FirebaseAuthException(
        code: e.toString(),
        message: "Error during Sign-In",
      );
    }
  }
}
