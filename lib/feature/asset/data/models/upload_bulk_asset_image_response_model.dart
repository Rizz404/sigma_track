import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/data/models/asset_image_upload_result_model.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_bulk_asset_image_response.dart';

class UploadBulkAssetImageResponseModel extends Equatable {
  final List<AssetImageUploadResultModel> results;
  final int count;

  const UploadBulkAssetImageResponseModel({
    required this.results,
    required this.count,
  });

  UploadBulkAssetImageResponseModel copyWith({
    List<AssetImageUploadResultModel>? results,
    int? count,
  }) {
    return UploadBulkAssetImageResponseModel(
      results: results ?? this.results,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'results': results.map((x) => x.toMap()).toList(), 'count': count};
  }

  factory UploadBulkAssetImageResponseModel.fromMap(Map<String, dynamic> map) {
    return UploadBulkAssetImageResponseModel(
      results: List<AssetImageUploadResultModel>.from(
        (map['results'] ?? []).map<AssetImageUploadResultModel>(
          (x) => AssetImageUploadResultModel.fromMap(x),
        ),
      ),
      count: map['count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UploadBulkAssetImageResponseModel.fromJson(String source) =>
      UploadBulkAssetImageResponseModel.fromMap(json.decode(source));

  UploadBulkAssetImageResponse toEntity() {
    return UploadBulkAssetImageResponse(
      results: results.map((x) => x.toEntity()).toList(),
      count: count,
    );
  }

  @override
  String toString() {
    return 'UploadBulkAssetImageResponseModel(count: $count, results: ${results.length} items)';
  }

  @override
  List<Object> get props => [results, count];
}
