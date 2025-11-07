import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

/// Use case for getting user profile
class GetUserProfile
    implements UseCase<UserProfile, NoParams> {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}

