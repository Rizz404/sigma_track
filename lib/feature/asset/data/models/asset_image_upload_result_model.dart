import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_image_upload_result.dart';

class AssetImageUploadResultModel extends Equatable {
  final String assetId;
  final String? imageUrl;
  final bool success;
  final String? error;

  const AssetImageUploadResultModel({
    required this.assetId,
    this.imageUrl,
    required this.success,
    this.error,
  });

  AssetImageUploadResultModel copyWith({
    String? assetId,
    String? imageUrl,
    bool? success,
    String? error,
  }) {
    return AssetImageUploadResultModel(
      assetId: assetId ?? this.assetId,
      imageUrl: imageUrl ?? this.imageUrl,
      success: success ?? this.success,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'imageUrl': imageUrl,
      'success': success,
      'error': error,
    };
  }

  factory AssetImageUploadResultModel.fromMap(Map<String, dynamic> map) {
    return AssetImageUploadResultModel(
      assetId: map['assetId'] ?? '',
      imageUrl: map['imageUrl'],
      success: map['success'] ?? false,
      error: map['error'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetImageUploadResultModel.fromJson(String source) =>
      AssetImageUploadResultModel.fromMap(json.decode(source));

  AssetImageUploadResult toEntity() {
    return AssetImageUploadResult(
      assetId: assetId,
      imageUrl: imageUrl,
      success: success,
      error: error,
    );
  }

  @override
  String toString() {
    return 'AssetImageUploadResultModel(assetId: $assetId, success: $success, imageUrl: $imageUrl, error: $error)';
  }

  @override
  List<Object?> get props => [assetId, imageUrl, success, error];
}
