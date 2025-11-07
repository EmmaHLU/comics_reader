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

  // ========================================
  // Preferences
  // ========================================

  /// Get user preferences
  Future<Either<Failure, UserPreferences>> getUserPreferences(String userId);

  /// Update user preferences
  Future<Either<Failure, Unit>> updateUserPreferences({
    required String userId,
    required UserPreferences preferences,
  });

  /// Update specific preference
  Future<Either<Failure, Unit>> updatePreference({
    required String userId,
    required String key,
    required dynamic value,
  });

}
