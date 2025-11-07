import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base class for all use cases in the application.
/// A use case represents a single unit of business logic.
///
/// Type [Type] is the return type wrapped in Either
/// Type [Params] is the input parameters type
abstract class UseCase<Type, Params> {
  /// Execute the use case with given [params]
  /// Returns Either<Failure, Type> 
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case for operations that don't require parameters
class NoParams {
  const NoParams();
}

/// Use case for synchronous operations
abstract class SyncUseCase<Type, Params> {
  /// Execute the use case synchronously with given [params]
  Either<Failure, Type> call(Params params);
}

/// Use case for stream-based operations
abstract class StreamUseCase<Type, Params> {
  /// Execute the use case and return a stream of results
  Stream<Either<Failure, Type>> call(Params params);
}
