import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

// Server Failure
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

// Cache Failure
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred']) : super(message);
}

// Network Failure
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

// Validation Failure
class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error occurred']) : super(message);
}

// Authentication Failure
class AuthenticationFailure extends Failure {
  const AuthenticationFailure([String message = 'Authentication failed']) : super(message);
}

// Permission Failure
class PermissionFailure extends Failure {
  const PermissionFailure([String message = 'Permission denied']) : super(message);
}
