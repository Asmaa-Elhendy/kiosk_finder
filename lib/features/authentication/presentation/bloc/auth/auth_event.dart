import 'package:equatable/equatable.dart';
import 'package:kiosk_finder/features/authentication/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class SignUpEvent extends AuthEvent {
  final UserEntity user;
  const SignUpEvent({required this.user});
  @override
  List<Object?> get props => [user];
}

class SignInEvent extends AuthEvent {
  final UserEntity user;
  const SignInEvent({required this.user});
  @override
  List<Object?> get props => [user];
}
