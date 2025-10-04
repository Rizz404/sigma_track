import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/core/network/models/pagination_info.dart';

class ApiOffsetPaginationResponse<T> extends ApiResponse<List<T>>
    with EquatableMixin {
  final PaginationInfo pagination;

  const ApiOffsetPaginationResponse({
    required super.status,
    required super.message,
    required super.data,
    required this.pagination,
  }) : super();

  factory ApiOffsetPaginationResponse.fromMap(
    Map<String, dynamic> map,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiOffsetPaginationResponse<T>(
      status: map.getFieldOrNull<String>('status') ?? 'unknown',
      message: map.getFieldOrNull<String>('message') ?? 'Unknown message',
      data: (map['data'] as List<dynamic>)
          .map((item) => fromJsonT(item))
          .toList(),
      pagination: PaginationInfo.fromMap(
        map['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  ApiOffsetPaginationResponse<T> copyWith({
    String? status,
    String? message,
    List<T>? data,
    PaginationInfo? pagination,
  }) {
    return ApiOffsetPaginationResponse<T>(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  String toString() =>
      'ApiOffsetPaginationResponse(status: $status, message: $message, data: $data, pagination: $pagination)';

  @override
  List<Object> get props => [status, message, data, pagination];

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data,
      'pagination': pagination.toMap(),
    };
  }
}
