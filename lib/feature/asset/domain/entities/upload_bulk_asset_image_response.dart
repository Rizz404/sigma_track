import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_image_upload_result.dart';

class UploadBulkAssetImageResponse extends Equatable {
  final List<AssetImageUploadResult> results;
  final int count;

  const UploadBulkAssetImageResponse({
    required this.results,
    required this.count,
  });

  UploadBulkAssetImageResponse copyWith({
    List<AssetImageUploadResult>? results,
    int? count,
  }) {
    return UploadBulkAssetImageResponse(
      results: results ?? this.results,
      count: count ?? this.count,
    );
  }

  @override
  String toString() {
    return 'UploadBulkAssetImageResponse(count: $count, results: ${results.length} items)';
  }

  @override
  List<Object> get props => [results, count];
}
