import 'dart:convert';

import 'package:equatable/equatable.dart';

class CursorInfo extends Equatable {
  final String nextCursor;
  final bool hasNextPage;
  final int perPage;

  const CursorInfo({
    required this.nextCursor,
    required this.hasNextPage,
    required this.perPage,
  });

  CursorInfo copyWith({String? nextCursor, bool? hasNextPage, int? perPage}) {
    return CursorInfo(
      nextCursor: nextCursor ?? this.nextCursor,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nextCursor': nextCursor,
      'hasNextPage': hasNextPage,
      'perPage': perPage,
    };
  }

  factory CursorInfo.fromMap(Map<String, dynamic> map) {
    return CursorInfo(
      nextCursor: map['nextCursor'] ?? '',
      hasNextPage: map['hasNextPage'] ?? false,
      perPage: map['perPage']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CursorInfo.fromJson(String source) =>
      CursorInfo.fromMap(json.decode(source));

  @override
  String toString() =>
      'CursorInfo(nextCursor: $nextCursor, hasNextPage: $hasNextPage, perPage: $perPage)';

  @override
  List<Object> get props => [nextCursor, hasNextPage, perPage];
}
