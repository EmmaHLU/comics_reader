import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constants.dart';
import '../models/user_model.dart';

/// Abstract interface for remote auth operations
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  /// Throws [AuthException] on failure
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email, password, and display name
  /// Throws [AuthException] on failure
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Sign out current user
  /// Throws [AuthException] on failure
  Future<void> signOut();

  /// Get current user
  /// Throws [NotFoundException] if no user is signed in
  Future<UserModel> getCurrentUser();

  /// Stream of auth state changes
  Stream<UserModel?> get authStateChanges;


  /// Get user data from Firestore
  /// Throws [ServerException] on failure
  Future<UserModel> getUserFromFirestore(String uid);
}

/// Implementation of AuthRemoteDataSource using Firebase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Sign in failed - no user returned');
      }

      // Get additional user data from Firestore
      try {
        return await getUserFromFirestore(credential.user!.uid);
      } catch (e) {
        // If Firestore data doesn't exist, create from Firebase User
        return UserModel.fromFirebaseUser(credential.user!);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        e.message ?? 'Sign in failed',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AuthException(
        'Sign in failed: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw const AuthException('Sign up failed - no user returned');
      }
      debugPrint( 'User created with UID: ${credential.user!.uid}');
      // Update display name
      await credential.user!.updateDisplayName(displayName);
      await credential.user!.reload();
      final updatedUser = firebaseAuth.currentUser!;

      // Create user document in Firestore
      final userModel = UserModel.fromFirebaseUser(updatedUser);
      // await firestore
      //     .collection(AppConstants.usersCollection)
      //     .doc(userModel.uid)
      //     .set(userModel.toFirestore());

      return userModel;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        e.message ?? 'Sign up failed',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AuthException(
        'Sign up failed: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(
        e.message ?? 'Sign out failed',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      throw AuthException(
        'Sign out failed: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;

      if (user == null) {
        throw const NotFoundException('No user is currently signed in');
      }

      // Try to get full user data from Firestore
      try {
        return await getUserFromFirestore(user.uid);
      } catch (e) {
        // Fallback to Firebase User data
        return UserModel.fromFirebaseUser(user);
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw AuthException(
        'Failed to get current user: ${e.toString()}',
        originalException: e,
      );
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      // Try to get full user data from Firestore
      try {
        return await getUserFromFirestore(user.uid);
      } catch (e) {
        // Fallback to Firebase User data
        return UserModel.fromFirebaseUser(user);
      }
    });
  }


  @override
  Future<UserModel> getUserFromFirestore(String uid) async {
    try {
      final doc = await _getUserDoc(uid).get();

      if (!doc.exists) {
        throw NotFoundException('User document not found for uid: $uid');
      }

      return UserModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw ServerException(
        'Failed to get user from Firestore: ${e.message}',
        code: e.code,
        originalException: e,
      );
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw ServerException(
        'Failed to get user from Firestore: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Helper to get user document reference
  /// Uses the custom database ID for comics app
  DocumentReference<Map<String, dynamic>> _getUserDoc(String uid) {
    final customFirestore = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: 'default',
    );
    return customFirestore.collection(AppConstants.usersCollection).doc(uid);
  }
}
