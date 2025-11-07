import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/credentials_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

/// Implementation of AuthRepository
/// Coordinates between remote and local data sources
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    debugPrint('start to signed up: ');
    try {
      final user = await remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      debugPrint('User signed up: ${user.uid}');
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await remoteDataSource.signOut();
      // Also delete saved credentials on sign out
      await localDataSource.deleteSavedCredentials();
      return const Right(unit);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message, code: e.code));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return remoteDataSource.authStateChanges;
  }

  @override
  Future<Either<Failure, Unit>> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await localDataSource.saveCredentials(
        email: email,
        password: password,
      );
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Credentials>> loadSavedCredentials() async {
    try {
      final credentials = await localDataSource.loadSavedCredentials();
      return Right(credentials);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSavedCredentials() async {
    try {
      await localDataSource.deleteSavedCredentials();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

}
