import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_bulk_data_matrix_response.dart';

class UploadBulkDataMatrixResponseModel extends Equatable {
  final List<String> urls;
  final int count;
  final List<String> assetTags;

  const UploadBulkDataMatrixResponseModel({
    required this.urls,
    required this.count,
    required this.assetTags,
  });

  UploadBulkDataMatrixResponseModel copyWith({
    List<String>? urls,
    int? count,
    List<String>? assetTags,
  }) {
    return UploadBulkDataMatrixResponseModel(
      urls: urls ?? this.urls,
      count: count ?? this.count,
      assetTags: assetTags ?? this.assetTags,
    );
  }

  Map<String, dynamic> toMap() {
    return {'urls': urls, 'count': count, 'assetTags': assetTags};
  }

  factory UploadBulkDataMatrixResponseModel.fromMap(Map<String, dynamic> map) {
    return UploadBulkDataMatrixResponseModel(
      urls: List<String>.from(map['urls'] ?? []),
      count: map['count'] ?? 0,
      assetTags: List<String>.from(map['assetTags'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UploadBulkDataMatrixResponseModel.fromJson(String source) =>
      UploadBulkDataMatrixResponseModel.fromMap(json.decode(source));

  UploadBulkDataMatrixResponse toEntity() {
    return UploadBulkDataMatrixResponse(
      urls: urls,
      count: count,
      assetTags: assetTags,
    );
  }

  @override
  String toString() {
    return 'UploadBulkDataMatrixResponseModel(count: $count, assetTags: $assetTags)';
  }

  @override
  List<Object> get props => [urls, count, assetTags];
}
