

import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoadingAuthState extends AuthState {}

class MessageAuthState extends AuthState {
  final String message;
  const MessageAuthState({required this.message});
  @override
  List<Object> get props => [message];
}

class ErrorAuthState extends AuthState {
  final String message;
  const ErrorAuthState({required this.message});
  @override
  List<Object> get props => [message];
}
