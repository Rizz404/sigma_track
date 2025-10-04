import 'dart:convert';
import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class ApiResponse<T> extends Equatable {
  final String status;
  final String message;
  final T data;

  const ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  ApiResponse<T> copyWith({String? status, String? message, T? data}) {
    return ApiResponse<T>(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory ApiResponse.fromMap(
    Map<String, dynamic> map,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      status: map.getFieldOrNull<String>('status') ?? 'unknown',
      message: map.getFieldOrNull<String>('message') ?? 'Unknown message',
      data: fromJsonT != null ? fromJsonT(map['data']) : map['data'] as T,
    );
  }

  factory ApiResponse.fromJson(
    String source,
    T Function(dynamic json)? fromJsonT,
  ) => ApiResponse.fromMap(json.decode(source), fromJsonT);

  @override
  List<Object?> get props => [status, message, data];
}
