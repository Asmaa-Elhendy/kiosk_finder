import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? password;

  const UserEntity({
    required this.id,
    required this.email,
    this.password,
  });

  @override
  List<Object?> get props => [id, email];
}
