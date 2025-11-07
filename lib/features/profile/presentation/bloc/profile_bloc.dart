import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_assistant/core/usecase/usecase.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

/// BLoC for managing user profile functionality
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserProfile getUserProfile;
  final ProfileRepository profileRepository;

  ProfileBloc({
    required this.getUserProfile,
    required this.profileRepository,
  }) : super(const ProfileInitial()) {
    // Register event handlers
    on<ProfileLoadRequested>(_onLoadRequested);
    on<ProfileUpdateDisplayNameRequested>(_onUpdateDisplayNameRequested);
    on<ProfileUpdatePreferencesRequested>(_onUpdatePreferencesRequested);
  }

  Future<void> _onLoadRequested(
    ProfileLoadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    final result = await getUserProfile(
      const NoParams(),
    );

    result.fold(
      (failure) => emit(ProfileError(failure, _getFailureMessage(failure))),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateDisplayNameRequested(
    ProfileUpdateDisplayNameRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await profileRepository.updateDisplayName(
      userId: event.userId,
      displayName: event.displayName,
    );

    result.fold(
      (failure) => emit(ProfileError(failure, _getFailureMessage(failure))),
      (_) => emit(const ProfileUpdated()),
    );
  }

  Future<void> _onUpdatePreferencesRequested(
    ProfileUpdatePreferencesRequested event,
    Emitter<ProfileState> emit,
  ) async {
    final result = await profileRepository.updateUserPreferences(
      userId: event.userId,
      preferences: event.preferences,
    );

    result.fold(
      (failure) => emit(ProfileError(failure, _getFailureMessage(failure))),
      (_) => emit(const ProfileUpdated()),
    );
  }



  String _getFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      case AuthFailure:
        return 'Authentication error: ${failure.message}';
      case CacheFailure:
        return 'Cache error: ${failure.message}';
      default:
        return failure.message;
    }
  }
}
