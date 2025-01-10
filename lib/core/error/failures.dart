import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FirebaseAuthFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserNotFoundFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WrongPasswordFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmailAlreadyInUseFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WeakPasswordFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InvalidEmailFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
