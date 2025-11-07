import 'package:equatable/equatable.dart';

import '../../domain/entities/user_profile_entity.dart';

/// Base class for all profile events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load user profile
class ProfileLoadRequested extends ProfileEvent {

  const ProfileLoadRequested();

}

/// Event to update display name
class ProfileUpdateDisplayNameRequested extends ProfileEvent {
  final String userId;
  final String displayName;

  const ProfileUpdateDisplayNameRequested({
    required this.userId,
    required this.displayName,
  });

  @override
  List<Object> get props => [userId, displayName];
}

/// Event to update preferences
class ProfileUpdatePreferencesRequested extends ProfileEvent {
  final String userId;
  final UserPreferences preferences;

  const ProfileUpdatePreferencesRequested({
    required this.userId,
    required this.preferences,
  });

  @override
  List<Object> get props => [userId, preferences];
}

/// Event to load meditation statistics
class ProfileLoadMeditationStatsRequested extends ProfileEvent {
  final String userId;

  const ProfileLoadMeditationStatsRequested(this.userId);

  @override
  List<Object> get props => [userId];
}
