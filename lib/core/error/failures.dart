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
