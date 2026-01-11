import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/domain/entities/delete_bulk_asset_image_response.dart';

class DeleteBulkAssetImageResponseModel extends Equatable {
  final int deletedCount;
  final List<String> failedIds;
  final List<String> assetImageIds;
  final int orphanedCleaned;

  const DeleteBulkAssetImageResponseModel({
    required this.deletedCount,
    required this.failedIds,
    required this.assetImageIds,
    required this.orphanedCleaned,
  });

  DeleteBulkAssetImageResponseModel copyWith({
    int? deletedCount,
    List<String>? failedIds,
    List<String>? assetImageIds,
    int? orphanedCleaned,
  }) {
    return DeleteBulkAssetImageResponseModel(
      deletedCount: deletedCount ?? this.deletedCount,
      failedIds: failedIds ?? this.failedIds,
      assetImageIds: assetImageIds ?? this.assetImageIds,
      orphanedCleaned: orphanedCleaned ?? this.orphanedCleaned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'deletedCount': deletedCount,
      'failedIds': failedIds,
      'assetImageIds': assetImageIds,
      'orphanedCleaned': orphanedCleaned,
    };
  }

  factory DeleteBulkAssetImageResponseModel.fromMap(Map<String, dynamic> map) {
    return DeleteBulkAssetImageResponseModel(
      deletedCount: map['deletedCount'] ?? 0,
      failedIds: List<String>.from(map['failedIds'] ?? []),
      assetImageIds: List<String>.from(map['assetImageIds'] ?? []),
      orphanedCleaned: map['orphanedCleaned'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeleteBulkAssetImageResponseModel.fromJson(String source) =>
      DeleteBulkAssetImageResponseModel.fromMap(json.decode(source));

  DeleteBulkAssetImageResponse toEntity() {
    return DeleteBulkAssetImageResponse(
      deletedCount: deletedCount,
      failedIds: failedIds,
      assetImageIds: assetImageIds,
      orphanedCleaned: orphanedCleaned,
    );
  }

  @override
  String toString() {
    return 'DeleteBulkAssetImageResponseModel(deletedCount: $deletedCount, failedIds: $failedIds, assetImageIds: $assetImageIds, orphanedCleaned: $orphanedCleaned)';
  }

  @override
  List<Object> get props => [
    deletedCount,
    failedIds,
    assetImageIds,
    orphanedCleaned,
  ];
}
