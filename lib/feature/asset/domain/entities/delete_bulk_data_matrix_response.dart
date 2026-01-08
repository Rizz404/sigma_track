import 'package:equatable/equatable.dart';

class DeleteBulkDataMatrixResponse extends Equatable {
  final int deletedCount;
  final List<String> failedTags;
  final List<String> assetTags;

  const DeleteBulkDataMatrixResponse({
    required this.deletedCount,
    required this.failedTags,
    required this.assetTags,
  });

  DeleteBulkDataMatrixResponse copyWith({
    int? deletedCount,
    List<String>? failedTags,
    List<String>? assetTags,
  }) {
    return DeleteBulkDataMatrixResponse(
      deletedCount: deletedCount ?? this.deletedCount,
      failedTags: failedTags ?? this.failedTags,
      assetTags: assetTags ?? this.assetTags,
    );
  }

  @override
  String toString() {
    return 'DeleteBulkDataMatrixResponse(deletedCount: $deletedCount, failedTags: $failedTags, assetTags: $assetTags)';
  }

  @override
  List<Object> get props => [deletedCount, failedTags, assetTags];
}
