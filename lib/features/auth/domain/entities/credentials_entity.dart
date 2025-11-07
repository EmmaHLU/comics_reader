import 'package:equatable/equatable.dart';

/// Domain entity representing stored user credentials
class Credentials extends Equatable {
  final String email;
  final String password;

  const Credentials({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];

  @override
  String toString() => 'CredentialsEntity(email: $email)';
}
