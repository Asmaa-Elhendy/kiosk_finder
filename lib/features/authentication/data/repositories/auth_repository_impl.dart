import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiosk_finder/features/authentication/domain/repositories/auth_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../datasources/user_firebase_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remoteFirebaseDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteFirebaseDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signUp(UserEntity user) async {
    final UserModel userModel = UserModel(
      id: user.id,
      email: user.email,
      password: user.password,
    );
    return await _getMessage(() => remoteFirebaseDataSource.signUp(userModel));
  }

  @override
  Future<Either<Failure, UserEntity>> signIn(UserEntity user) async {
    final UserModel userModel = UserModel(
      email: user.email,
      password: user.password,
      id: user.id,
    );
    print("in innnnnnnnnnnn ${user.email}");
    return await _getMessage(() => remoteFirebaseDataSource.signIn(userModel));
  }

  Future<Either<Failure, UserEntity>> _getMessage(
      Future<UserModel> Function() fun) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await fun();
        // Map UserModel back to UserEntity
        return Right(UserEntity(
          email: userModel.email,
          password: userModel.password,
          id: userModel.id,
        ));
      } on UserNotFoundException {
        return Left(UserNotFoundFailure());
      } on WrongPasswordException {
        return Left(WrongPasswordFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on WeakPasswordException {
        return Left(WeakPasswordFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on FirebaseAuthException {
        return Left(FirebaseAuthFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
