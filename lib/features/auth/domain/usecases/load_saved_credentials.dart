import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/credentials_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for loading saved credentials
class LoadSavedCredentials implements UseCase<Credentials, NoParams> {
  final AuthRepository repository;

  LoadSavedCredentials(this.repository);

  @override
  Future<Either<Failure, Credentials>> call(NoParams params) async {
    return await repository.loadSavedCredentials();
  }
}
