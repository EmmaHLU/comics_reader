import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/credentials_model.dart';

/// Abstract interface for local auth operations
abstract class AuthLocalDataSource {
  /// Save credentials to secure storage
  /// Throws [CacheException] on failure
  Future<void> saveCredentials({
    required String email,
    required String password,
  });

  /// Load saved credentials from secure storage
  /// Throws [NotFoundException] if no credentials are saved
  /// Throws [CacheException] on failure
  Future<CredentialsModel> loadSavedCredentials();

  /// Delete saved credentials
  /// Throws [CacheException] on failure
  Future<void> deleteSavedCredentials();

  /// Check if credentials are saved
  Future<bool> hasCredentials();
}

/// Implementation of AuthLocalDataSource using FlutterSecureStorage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
  });

  @override
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final credentials = CredentialsModel(
        email: email,
        password: password,
      );

      final jsonString = json.encode(credentials.toJson());

      await secureStorage.write(
        key: AppConstants.credentialsKey,
        value: jsonString,
      );
    } catch (e) {
      throw CacheException(
        'Failed to save credentials: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<CredentialsModel> loadSavedCredentials() async {
    try {
      final jsonString = await secureStorage.read(
        key: AppConstants.credentialsKey,
      );

      if (jsonString == null) {
        throw const NotFoundException('No saved credentials found');
      }

      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return CredentialsModel.fromJson(jsonMap);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw CacheException(
        'Failed to load credentials: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<void> deleteSavedCredentials() async {
    try {
      await secureStorage.delete(key: AppConstants.credentialsKey);
    } catch (e) {
      throw CacheException(
        'Failed to delete credentials: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<bool> hasCredentials() async {
    try {
      final jsonString = await secureStorage.read(
        key: AppConstants.credentialsKey,
      );
      return jsonString != null;
    } catch (e) {
      return false;
    }
  }
}
