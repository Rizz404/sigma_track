import 'dart:convert';

import 'package:equatable/equatable.dart';

class BulkDeleteParams extends Equatable {
  final List<String> ids;

  BulkDeleteParams({required this.ids});

  BulkDeleteParams copyWith({List<String>? ids}) {
    return BulkDeleteParams(ids: ids ?? this.ids);
  }

  Map<String, dynamic> toMap() {
    return {'ids': ids};
  }

  factory BulkDeleteParams.fromMap(Map<String, dynamic> map) {
    return BulkDeleteParams(ids: List<String>.from(map['ids']));
  }

  String toJson() => json.encode(toMap());

  factory BulkDeleteParams.fromJson(String source) =>
      BulkDeleteParams.fromMap(json.decode(source));

  @override
  String toString() => 'BulkDeleteParams(ids: $ids)';

  @override
  List<Object> get props => [ids];
}
