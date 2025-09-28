import 'dart:convert';

import 'package:equatable/equatable.dart';

class CursorInfo extends Equatable {
  final int total;
  final int perPage;
  final int currentPage;
  final int totalPages;
  final bool hasPrevPage;
  final bool hasNextPage;

  const CursorInfo({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    required this.hasPrevPage,
    required this.hasNextPage,
  });

  CursorInfo copyWith({
    int? total,
    int? perPage,
    int? currentPage,
    int? totalPages,
    bool? hasPrevPage,
    bool? hasNextPage,
  }) {
    return CursorInfo(
      total: total ?? this.total,
      perPage: perPage ?? this.perPage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasPrevPage: hasPrevPage ?? this.hasPrevPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'perPage': perPage,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasPrevPage': hasPrevPage,
      'hasNextPage': hasNextPage,
    };
  }

  factory CursorInfo.fromMap(Map<String, dynamic> map) {
    return CursorInfo(
      total: map['total']?.toInt() ?? 0,
      perPage: map['perPage']?.toInt() ?? 0,
      currentPage: map['currentPage']?.toInt() ?? 0,
      totalPages: map['totalPages']?.toInt() ?? 0,
      hasPrevPage: map['hasPrevPage'] ?? false,
      hasNextPage: map['hasNextPage'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CursorInfo.fromJson(String source) =>
      CursorInfo.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CursorInfo(total: $total, perPage: $perPage, currentPage: $currentPage, totalPages: $totalPages, hasPrevPage: $hasPrevPage, hasNextPage: $hasNextPage)';
  }

  @override
  List<Object> get props {
    return [total, perPage, currentPage, totalPages, hasPrevPage, hasNextPage];
  }
}
