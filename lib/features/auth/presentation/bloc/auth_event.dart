import 'package:equatable/equatable.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current authentication status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event to sign in with email and password
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  final bool saveCredentials;

  const AuthSignInRequested({
    required this.email,
    required this.password,
    this.saveCredentials = false,
  });

  @override
  List<Object?> get props => [email, password, saveCredentials];
}

/// Event to sign up with email, password, and display name
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

/// Event to sign out
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Event to auto-login with saved credentials
class AuthAutoLoginRequested extends AuthEvent {
  const AuthAutoLoginRequested();
}

/// Event when auth state changes (from Firebase stream)
class AuthStateChanged extends AuthEvent {
  final bool isAuthenticated;

  const AuthStateChanged({required this.isAuthenticated});

  @override
  List<Object?> get props => [isAuthenticated];
}

/// Event to check trial status
class AuthTrialCheckRequested extends AuthEvent {
  const AuthTrialCheckRequested();
}

/// Event to initialize trial
class AuthTrialInitializeRequested extends AuthEvent {
  const AuthTrialInitializeRequested();
}

/// Event to update subscription status
class AuthSubscriptionUpdateRequested extends AuthEvent {
  final bool isSubscribed;

  const AuthSubscriptionUpdateRequested({required this.isSubscribed});

  @override
  List<Object?> get props => [isSubscribed];
}
