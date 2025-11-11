/// Base class for all exceptions thrown in the data layer.
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  const AppException(
    this.message, {
    this.code,
    this.originalException,
  });

  @override
  String toString() {
    if (originalException != null) {
      return 'AppException: $message (Code: $code, Original: $originalException)';
    }
    return 'AppException: $message (Code: $code)';
  }
}

/// Exception when a server/API call fails
class ServerException extends AppException {
  const ServerException(
    super.message, {
    super.code,
    super.originalException,
  });
}

/// Exception when there's no internet connection
class NetworkException extends AppException {
  const NetworkException(
    super.message, {
    super.code,
    super.originalException,
  });
}

/// Exception when authentication fails
class AuthException extends AppException {
  const AuthException(
    super.message, {
    super.code,
    super.originalException,
  });
}

/// Exception when accessing local storage/cache fails
class CacheException extends AppException {
  const CacheException(
    super.message, {
    super.code,
    super.originalException,
  });
}

/// Exception when validation fails
class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    super.code,
    super.originalException,
  });
}

/// Exception when a user is not authorized
class UnauthorizedException extends AppException {
  const UnauthorizedException(
    super.message, {
    super.code,
    super.originalException,
  });
}

/// Exception when a requested resource is not found
class NotFoundException extends AppException {
  const NotFoundException(
    super.message, {
    super.code,
    super.originalException,
  });
}

/// Exception when parsing data fails
class ParsingException extends AppException {
  const ParsingException(
    super.message, {
    super.code,
    super.originalException,
  });
}

