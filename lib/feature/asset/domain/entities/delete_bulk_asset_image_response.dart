import 'package:equatable/equatable.dart';

class DeleteBulkAssetImageResponse extends Equatable {
  final int deletedCount;
  final List<String> failedIds;
  final List<String> assetImageIds;
  final int orphanedCleaned;

  const DeleteBulkAssetImageResponse({
    required this.deletedCount,
    required this.failedIds,
    required this.assetImageIds,
    required this.orphanedCleaned,
  });

  DeleteBulkAssetImageResponse copyWith({
    int? deletedCount,
    List<String>? failedIds,
    List<String>? assetImageIds,
    int? orphanedCleaned,
  }) {
    return DeleteBulkAssetImageResponse(
      deletedCount: deletedCount ?? this.deletedCount,
      failedIds: failedIds ?? this.failedIds,
      assetImageIds: assetImageIds ?? this.assetImageIds,
      orphanedCleaned: orphanedCleaned ?? this.orphanedCleaned,
    );
  }

  @override
  String toString() {
    return 'DeleteBulkAssetImageResponse(deletedCount: $deletedCount, failedIds: $failedIds, assetImageIds: $assetImageIds, orphanedCleaned: $orphanedCleaned)';
  }

  @override
  List<Object> get props => [
    deletedCount,
    failedIds,
    assetImageIds,
    orphanedCleaned,
  ];
}
