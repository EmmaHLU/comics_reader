import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

/// Implementation of ProfileRepository
/// Aggregates data from auth and meditation repositories
class ProfileRepositoryImpl implements ProfileRepository {
  final AuthRepository authRepository;

  ProfileRepositoryImpl({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, UserProfile>> getUserProfile(
  ) async {
    try {
      // Get user from auth repository
      final userResult = await authRepository.getCurrentUser();

      return userResult.fold(
        (failure) => Left(failure),
        (user) {
          // Create profile entity
          final profile = UserProfile(
            userId: user.uid,
            email: user.email,
            displayName: user.displayName,
          );

          return Right(profile);
        },
      );
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUserProfile({
    required UserProfile profile,
  }) async {
    // Profile updates would be stored in Firestore
    // For now, return success
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updateDisplayName({
    required String userId,
    required String displayName,
  }) async {
    return const Right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updatePhotoUrl({
    required String userId,
    required String photoUrl,
  }) async {
    return const Right(unit);
  }

}
