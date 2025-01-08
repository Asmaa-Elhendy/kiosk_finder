import 'package:dartz/dartz.dart';
import 'package:kiosk_finder/features/authentication/domain/repositories/auth_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../datasources/user_firebase_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl extends AuthRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> signUp(UserEntity user) async {
    final UserModel userModel = UserModel(
      email: user.email,
      password: user.password,
      id: user.id ?? '0', // Use `id` from UserEntity if provided
    );
    return await _getMessage(() => remoteDataSource.signUp(userModel));
  }

  @override
  Future<Either<Failure, UserEntity>> signIn(UserEntity user) async {
    final UserModel userModel = UserModel(
      email: user.email,
      password: user.password,
      id: user.id ?? '0',
    );
    return await _getMessage(() => remoteDataSource.signIn(userModel));
  }

  Future<Either<Failure, UserEntity>> _getMessage(
      Future<UserModel> Function() fun) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await fun(); // Await the function result properly
        // Map UserModel back to UserEntity
        return Right(UserEntity(
          email: userModel.email,
          password: userModel.password,
          id: userModel.id,
        ));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
