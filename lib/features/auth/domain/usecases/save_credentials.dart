import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// Use case for saving credentials for auto-login
class SaveCredentials implements UseCase<Unit, SaveCredentialsParams> {
  final AuthRepository repository;

  SaveCredentials(this.repository);

  @override
  Future<Either<Failure, Unit>> call(SaveCredentialsParams params) async {
    return await repository.saveCredentials(
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for SaveCredentials use case
class SaveCredentialsParams extends Equatable {
  final String email;
  final String password;

  const SaveCredentialsParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
