import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/domain/entities/delete_bulk_data_matrix_response.dart';

class DeleteBulkDataMatrixResponseModel extends Equatable {
  final int deletedCount;
  final List<String> failedTags;
  final List<String> assetTags;

  const DeleteBulkDataMatrixResponseModel({
    required this.deletedCount,
    required this.failedTags,
    required this.assetTags,
  });

  DeleteBulkDataMatrixResponseModel copyWith({
    int? deletedCount,
    List<String>? failedTags,
    List<String>? assetTags,
  }) {
    return DeleteBulkDataMatrixResponseModel(
      deletedCount: deletedCount ?? this.deletedCount,
      failedTags: failedTags ?? this.failedTags,
      assetTags: assetTags ?? this.assetTags,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deletedCount': deletedCount,
      'failedTags': failedTags,
      'assetTags': assetTags,
    };
  }

  factory DeleteBulkDataMatrixResponseModel.fromMap(Map<String, dynamic> map) {
    return DeleteBulkDataMatrixResponseModel(
      deletedCount: map['deletedCount'] ?? 0,
      failedTags: List<String>.from(map['failedTags'] ?? []),
      assetTags: List<String>.from(map['assetTags'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeleteBulkDataMatrixResponseModel.fromJson(String source) =>
      DeleteBulkDataMatrixResponseModel.fromMap(json.decode(source));

  DeleteBulkDataMatrixResponse toEntity() {
    return DeleteBulkDataMatrixResponse(
      deletedCount: deletedCount,
      failedTags: failedTags,
      assetTags: assetTags,
    );
  }

  @override
  String toString() {
    return 'DeleteBulkDataMatrixResponseModel(deletedCount: $deletedCount, failedTags: $failedTags, assetTags: $assetTags)';
  }

  @override
  List<Object> get props => [deletedCount, failedTags, assetTags];
}
