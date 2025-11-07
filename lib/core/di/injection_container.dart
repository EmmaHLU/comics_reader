import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/load_saved_credentials.dart';
import '../../features/auth/domain/usecases/save_credentials.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/get_user_profile.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import 'injection_container.config.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await sl.init();
}

/// Manual dependency injection setup
/// This will be replaced by generated code after running build_runner
Future<void> initDependencies() async {
  // Auth Feature
  await _initAuth();

  // Comics Feature

  await _initComics();
  
  // Profile Feature
  await _initProfile();
}

/// Initialize Auth feature dependencies
Future<void> _initAuth() async {
  // External dependencies
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  const secureStorage = FlutterSecureStorage();

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: firebaseAuth,
      firestore: firestore,
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: secureStorage,
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SaveCredentials(sl()));
  sl.registerLazySingleton(() => LoadSavedCredentials(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      saveCredentials: sl(),
      loadSavedCredentials: sl(),
    ),
  );
}

Future<void> _initComics() async {
  // Repository 


  // Use cases

  // BLoC

}
/// Initialize Profile feature dependencies
Future<void> _initProfile() async {
  // Repository 
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      authRepository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));

  // BLoC
  sl.registerFactory(
    () => ProfileBloc(
      getUserProfile: sl(),
      profileRepository: sl(),
    ),
  );
}
/// Helper method to reset all dependencies
Future<void> resetDependencies() async {
  await sl.reset();
}
