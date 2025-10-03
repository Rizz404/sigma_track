import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class ApiErrorResponse extends Equatable {
  final String status;
  final String message;
  final List<ApiValidationError>? errors;

  const ApiErrorResponse({
    required this.status,
    required this.message,
    this.errors,
  });

  ApiErrorResponse copyWith({
    String? status,
    String? message,
    ValueGetter<List<ApiValidationError>?>? errors,
  }) {
    return ApiErrorResponse(
      status: status ?? this.status,
      message: message ?? this.message,
      errors: errors != null ? errors() : this.errors,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'errors': errors?.map((x) => x.toMap()).toList(),
    };
  }

  factory ApiErrorResponse.fromMap(Map<String, dynamic> map) {
    // * Mendukung "error" (singular) dan "errors" (plural) dari API
    final errorList = map['errors'] ?? map['error'];

    return ApiErrorResponse(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      errors: errorList != null
          ? List<ApiValidationError>.from(
              errorList?.map((x) => ApiValidationError.fromMap(x)),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiErrorResponse.fromJson(String source) =>
      ApiErrorResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'ApiErrorResponse(status: $status, message: $message, errors: $errors)';

  @override
  List<Object?> get props => [status, message, errors];
}

class ApiValidationError extends Equatable {
  final String field;
  final String tag;
  final String value;
  final String message;

  const ApiValidationError({
    required this.field,
    required this.tag,
    required this.value,
    required this.message,
  });

  ApiValidationError copyWith({
    String? field,
    String? tag,
    String? value,
    String? message,
  }) {
    return ApiValidationError(
      field: field ?? this.field,
      tag: tag ?? this.tag,
      value: value ?? this.value,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {'field': field, 'tag': tag, 'value': value, 'message': message};
  }

  factory ApiValidationError.fromMap(Map<String, dynamic> map) {
    return ApiValidationError(
      field: map['field'] ?? '',
      tag: map['tag'] ?? '',
      value: map['value'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiValidationError.fromJson(String source) =>
      ApiValidationError.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ApiValidationError(field: $field, tag: $tag, value: $value, message: $message)';
  }

  @override
  List<Object> get props => [field, tag, value, message];
}
