import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signUp(UserEntity user);
  Future<Either<Failure, UserEntity>> signIn(UserEntity user);
}
