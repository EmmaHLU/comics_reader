import 'package:equatable/equatable.dart';

/// Domain entity representing a user in the application.
class User extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool isEmailVerified;
  final DateTime? createdAt;

  const User({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isEmailVerified = false,
    this.createdAt,
  });



  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoUrl,
        isEmailVerified,
        createdAt,
      ];

  @override
  String toString() {
    return 'UserEntity(uid: $uid, email: $email, displayName: $displayName)';
  }
}
