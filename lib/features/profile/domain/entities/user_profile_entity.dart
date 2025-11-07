import 'package:equatable/equatable.dart';

/// Entity representing user profile
class UserProfile extends Equatable {
  final String userId;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;
  final UserPreferences preferences;

  const UserProfile({
    required this.userId,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.createdAt,
    this.lastLoginAt,
    this.preferences = const UserPreferences(),
  });

  /// Check if user has display name
  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;

  /// Check if user has photo
  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;

  /// Get user initials from display name or email
  String get initials {
    if (hasDisplayName) {
      final parts = displayName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName!.substring(0, 1).toUpperCase();
    }
    return email.substring(0, 1).toUpperCase();
  }

  
  @override
  List<Object?> get props => [
        userId,
        email,
        displayName,
        photoUrl,
        createdAt,
        lastLoginAt,
        preferences,
      ];
}

/// User preferences entity
class UserPreferences extends Equatable {
  final bool notificationsEnabled;
  final bool soundEnabled;
  final double defaultVolume;
  final double defaultSpeed;
  final String? preferredLanguage;
  final List<String> favoriteCategories;
  final String? theme; // light, dark, system

  const UserPreferences({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.defaultVolume = 0.8,
    this.defaultSpeed = 1.0,
    this.preferredLanguage,
    this.favoriteCategories = const [],
    this.theme = 'system',
  });

  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    double? defaultVolume,
    double? defaultSpeed,
    String? preferredLanguage,
    List<String>? favoriteCategories,
    String? theme,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      defaultVolume: defaultVolume ?? this.defaultVolume,
      defaultSpeed: defaultSpeed ?? this.defaultSpeed,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [
        notificationsEnabled,
        soundEnabled,
        defaultVolume,
        defaultSpeed,
        preferredLanguage,
        favoriteCategories,
        theme,
      ];
}
