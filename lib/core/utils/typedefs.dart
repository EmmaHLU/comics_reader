import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Common type definitions used throughout the application

/// Result type alias for operations that return Either<Failure, T>
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// Result type alias for synchronous operations
typedef SyncEither<T> = Either<Failure, T>;

/// Stream result type alias
typedef StreamEither<T> = Stream<Either<Failure, T>>;

/// JSON type alias
typedef JSON = Map<String, dynamic>;
