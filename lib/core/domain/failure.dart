import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  final List<ValidationError>? errors;

  @override
  List<Object?> get props => [message, errors];

  const ValidationFailure({required super.message, this.errors});
}

class NetworkFailure extends Failure {
  @override
  List<Object?> get props => [message];

  const NetworkFailure({required super.message});
}

class ValidationError extends Equatable {
  final String field;
  final String tag;
  final String value;
  final String message;

  const ValidationError({
    required this.field,
    required this.tag,
    required this.value,
    required this.message,
  });

  @override
  List<Object?> get props => [field, tag, value, message];
}
