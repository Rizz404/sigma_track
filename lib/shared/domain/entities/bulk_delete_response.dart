import 'dart:convert';

import 'package:equatable/equatable.dart';

class BulkDeleteResponse extends Equatable {
  final List<String> requestedIds;
  final List<String> deletedIds;

  BulkDeleteResponse({required this.requestedIds, required this.deletedIds});

  BulkDeleteResponse copyWith({
    List<String>? requestedIds,
    List<String>? deletedIds,
  }) {
    return BulkDeleteResponse(
      requestedIds: requestedIds ?? this.requestedIds,
      deletedIds: deletedIds ?? this.deletedIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {'requestedIds': requestedIds, 'deletedIds': deletedIds};
  }

  factory BulkDeleteResponse.fromMap(Map<String, dynamic> map) {
    return BulkDeleteResponse(
      requestedIds: List<String>.from(map['requestedIds']),
      deletedIds: List<String>.from(map['deletedIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkDeleteResponse.fromJson(String source) =>
      BulkDeleteResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'BulkDeleteResponse(requestedIds: $requestedIds, deletedIds: $deletedIds)';

  @override
  List<Object> get props => [requestedIds, deletedIds];
}
