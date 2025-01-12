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

class FirestoreWriteFailure extends Failure {
  final String message;
  FirestoreWriteFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class FirestoreReadFailure extends Failure {
  final String message;
  FirestoreReadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class FileReadFailure extends Failure {
  final String message;
  FileReadFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UnexpectedFailure extends Failure {
  final String message;
  UnexpectedFailure(this.message);

  @override
  List<Object?> get props => [message];
}
