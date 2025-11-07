import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/load_saved_credentials.dart';
import '../../domain/usecases/save_credentials.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final SaveCredentials saveCredentials;
  final LoadSavedCredentials loadSavedCredentials;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.getCurrentUser,
    required this.saveCredentials,
    required this.loadSavedCredentials,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthAutoLoginRequested>(_onAuthAutoLoginRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUser(const NoParams());

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) async {

        emit(AuthAuthenticated(
          user: user,
        ));
      },
    );
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSigningIn());

    final result = await signIn(SignInParams(
      email: event.email,
      password: event.password,
    ));

    await result.fold(
      (failure) async {
        emit(AuthError(
          message: failure.message,
          code: failure.code,
        ));
      },
      (user) async {
        // Save credentials if requested
        if (event.saveCredentials) {
          await saveCredentials(SaveCredentialsParams(
            email: event.email,
            password: event.password,
          ));
        }

        emit(AuthAuthenticated(
          user: user,
        ));
      },
    );
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSigningUp());
    final result = await signUp(SignUpParams(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    ));
    debugPrint('after Signing up user with email: ${event.email}');

    await result.fold(
      (failure) async {
        emit(AuthError(
          message: failure.message,
          code: failure.code,
        ));
      },
      (user) async {
        debugPrint('Sign up succeeded for user: ${user.uid}');
        emit(AuthAuthenticated(
          user: user,
        ));
      },
    );
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSigningOut());

    final result = await signOut(const NoParams());

    result.fold(
      (failure) => emit(AuthError(
        message: failure.message,
        code: failure.code,
      )),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthAutoLoginRequested(
    AuthAutoLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Try to load saved credentials
    final credentialsResult = await loadSavedCredentials(const NoParams());

    await credentialsResult.fold(
      (failure) async {
        // No saved credentials, check if user is already signed in
        final userResult = await getCurrentUser(const NoParams());
        userResult.fold(
          (failure) => emit(const AuthUnauthenticated()),
          (user) async {
            emit(AuthAuthenticated(
              user: user,
            ));
          },
        );
      },
      (credentials) async {
        // Try to sign in with saved credentials
        final signInResult = await signIn(SignInParams(
          email: credentials.email,
          password: credentials.password,
        ));

        await signInResult.fold(
          (failure) async {
            emit(const AuthUnauthenticated());
          },
          (user) async {
            emit(AuthAuthenticated(
              user: user,
            ));
          },
        );
      },
    );
  }
}
