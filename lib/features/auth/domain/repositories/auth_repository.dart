import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/credentials_entity.dart';
import '../entities/user_entity.dart';

/// Repository interface for authentication operations.
abstract class AuthRepository {
  /// Sign in with email and password
  /// Returns Either<Failure, User> 
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email, password, and display name
  /// Returns Either<Failure, User>
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign out the current user
  /// Returns Either<Failure, Unit> where Unit represents success with no data
  Future<Either<Failure, Unit>> signOut();

  /// Get the currently signed in user
  /// Returns Either<Failure, User>
  /// Returns NotFoundFailure if no user is signed in
  Future<Either<Failure, User>> getCurrentUser();

  /// Stream of authentication state changes
  /// Emits UserEntity when user signs in
  /// Emits null when user signs out
  Stream<User?> get authStateChanges;

  /// Save credentials locally for auto-login
  /// Returns Either<Failure, Unit>
  Future<Either<Failure, Unit>> saveCredentials({
    required String email,
    required String password,
  });

  /// Load saved credentials
  /// Returns Either<Failure, Credentials>
  /// Returns NotFoundFailure if no credentials saved
  Future<Either<Failure, Credentials>> loadSavedCredentials();

  /// Delete saved credentials
  /// Returns Either<Failure, Unit>
  Future<Either<Failure, Unit>> deleteSavedCredentials();

}
