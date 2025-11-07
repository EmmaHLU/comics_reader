import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
/// Failures represent errors that have been handled and converted
/// from exceptions in the data layer.
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Failure when a server call fails
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

/// Failure when there's no internet connection
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.code});
}

/// Failure when authentication fails
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

/// Failure when accessing local storage/cache
class CacheFailure extends Failure {
  const CacheFailure(super.message, {super.code});
}

/// Failure when validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

/// Failure when a user is not authorized
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code});
}

/// Failure when a requested resource is not found
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.code});
}

/// Failure when parsing data
class ParsingFailure extends Failure {
  const ParsingFailure(super.message, {super.code});
}

/// Generic/unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.code});
}
