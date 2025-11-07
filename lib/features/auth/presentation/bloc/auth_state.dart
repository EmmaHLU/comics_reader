import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when checking authentication status
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when authentication fails
class AuthError extends AuthState {
  final String message;
  final String? code;

  const AuthError({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// State when sign in is in progress
class AuthSigningIn extends AuthState {
  const AuthSigningIn();
}

/// State when sign up is in progress
class AuthSigningUp extends AuthState {
  const AuthSigningUp();
}

/// State when sign out is in progress
class AuthSigningOut extends AuthState {
  const AuthSigningOut();
}

/// State for trial checking
class AuthCheckingTrial extends AuthState {
  const AuthCheckingTrial();
}

/// State for trial initialized
class AuthTrialInitialized extends AuthState {
  const AuthTrialInitialized();
}

/// State for subscription updated
class AuthSubscriptionUpdated extends AuthState {
  final bool isSubscribed;

  const AuthSubscriptionUpdated({required this.isSubscribed});

  @override
  List<Object?> get props => [isSubscribed];
}
