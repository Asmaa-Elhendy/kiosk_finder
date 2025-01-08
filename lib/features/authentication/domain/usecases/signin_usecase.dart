import 'package:dartz/dartz.dart';
import 'package:kiosk_finder/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(UserEntity user) async {
    //call to make class callable as function
    return await repository.signIn(user);
  }
}
