import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile_entity.dart';

/// Base class for all profile states
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

/// Loading state
class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// State when profile is loaded
class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

/// State when profile is updated
class ProfileUpdated extends ProfileState {
  const ProfileUpdated();
}

/// Error state
class ProfileError extends ProfileState {
  final Failure failure;
  final String? message;

  const ProfileError(this.failure, [this.message]);

  @override
  List<Object?> get props => [failure, message];
}
