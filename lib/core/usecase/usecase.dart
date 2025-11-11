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
