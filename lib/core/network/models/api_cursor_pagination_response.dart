import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/core/network/models/cursor_info.dart';

class ApiCursorPaginationResponse<T> extends ApiResponse<List<T>>
    with EquatableMixin {
  final CursorInfo cursor;

  const ApiCursorPaginationResponse({
    required super.status,
    required super.message,
    required super.data,
    required this.cursor,
  }) : super();

  factory ApiCursorPaginationResponse.fromMap(
    Map<String, dynamic> map,
    T Function(dynamic json) fromJsonT,
  ) {
    final cursorData = map['cursor'];

    return ApiCursorPaginationResponse<T>(
      status: (map['status'] as String?) ?? 'unknown',
      message: map['message'] is String
          ? map['message']
          : (map['message']?.toString() ?? 'Unknown message'),
      data: (map['data'] as List<dynamic>)
          .map((item) => fromJsonT(item))
          .toList(),
      cursor: CursorInfo.fromMap(cursorData as Map<String, dynamic>),
    );
  }

  @override
  ApiCursorPaginationResponse<T> copyWith({
    String? status,
    String? message,
    List<T>? data,
    CursorInfo? cursor,
  }) {
    return ApiCursorPaginationResponse<T>(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
      cursor: cursor ?? this.cursor,
    );
  }

  @override
  String toString() =>
      'ApiCursorPaginationResponse(status: $status, message: $message, data: $data, cursor: $cursor)';

  @override
  List<Object?> get props => [status, message, data, cursor];

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data,
      'cursor': cursor.toMap(),
    };
  }
}
