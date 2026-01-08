import 'package:equatable/equatable.dart';

class UploadBulkDataMatrixResponse extends Equatable {
  final List<String> urls;
  final int count;
  final List<String> assetTags;

  const UploadBulkDataMatrixResponse({
    required this.urls,
    required this.count,
    required this.assetTags,
  });

  UploadBulkDataMatrixResponse copyWith({
    List<String>? urls,
    int? count,
    List<String>? assetTags,
  }) {
    return UploadBulkDataMatrixResponse(
      urls: urls ?? this.urls,
      count: count ?? this.count,
      assetTags: assetTags ?? this.assetTags,
    );
  }

  @override
  String toString() {
    return 'UploadBulkDataMatrixResponse(count: $count, assetTags: $assetTags)';
  }

  @override
  List<Object> get props => [urls, count, assetTags];
}
