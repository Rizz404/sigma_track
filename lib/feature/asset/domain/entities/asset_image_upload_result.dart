import 'package:equatable/equatable.dart';

class AssetImageUploadResult extends Equatable {
  final String assetId;
  final String? imageUrl;
  final bool success;
  final String? error;

  const AssetImageUploadResult({
    required this.assetId,
    this.imageUrl,
    required this.success,
    this.error,
  });

  AssetImageUploadResult copyWith({
    String? assetId,
    String? imageUrl,
    bool? success,
    String? error,
  }) {
    return AssetImageUploadResult(
      assetId: assetId ?? this.assetId,
      imageUrl: imageUrl ?? this.imageUrl,
      success: success ?? this.success,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'AssetImageUploadResult(assetId: $assetId, success: $success, imageUrl: $imageUrl, error: $error)';
  }

  @override
  List<Object?> get props => [assetId, imageUrl, success, error];
}
