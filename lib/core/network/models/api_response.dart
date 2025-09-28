import 'dart:convert';
import 'package:equatable/equatable.dart';

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
      status: (map['status'] as String?) ?? 'unknown',
      message: map['message'] is String
          ? map['message']
          : (map['message']?.toString() ?? 'Unknown message'),
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
