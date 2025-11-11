import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_profile_entity.dart';

/// Abstract repository interface for user profile feature
/// Defines contract for profile management, and preferences
abstract class ProfileRepository {
  // ========================================
  // Profile Management
  // ========================================

  /// Get user profile
  Future<Either<Failure, UserProfile>> getUserProfile();

  /// Update user profile
  Future<Either<Failure, Unit>> updateUserProfile({
    required UserProfile profile,
  });

  /// Update display name
  Future<Either<Failure, Unit>> updateDisplayName({
    required String userId,
    required String displayName,
  });

  /// Update photo URL
  Future<Either<Failure, Unit>> updatePhotoUrl({
    required String userId,
    required String photoUrl,
  });



}
