import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/credentials_entity.dart';

/// Data model for Credentials that extends the domain entity.
/// This handles serialization/deserialization for local storage.
class CredentialsModel extends Credentials {
  const CredentialsModel({
    required super.email,
    required super.password,
  });

  /// Create CredentialsModel from JSON
  factory CredentialsModel.fromJson(JSON json) {
    return CredentialsModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  /// Convert to JSON
  JSON toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  /// Create CredentialsModel from domain entity
  factory CredentialsModel.fromEntity(Credentials entity) {
    return CredentialsModel(
      email: entity.email,
      password: entity.password,
    );
  }

  /// Convert to domain entity
  Credentials toEntity() {
    return Credentials(
      email: email,
      password: password,
    );
  }
}
