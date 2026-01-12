import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_template_images_response.dart';

class UploadTemplateImagesResponseModel extends Equatable {
  final List<String> imageUrls;
  final int count;

  const UploadTemplateImagesResponseModel({
    required this.imageUrls,
    required this.count,
  });

  UploadTemplateImagesResponseModel copyWith({
    List<String>? imageUrls,
    int? count,
  }) {
    return UploadTemplateImagesResponseModel(
      imageUrls: imageUrls ?? this.imageUrls,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'imageUrls': imageUrls, 'count': count};
  }

  factory UploadTemplateImagesResponseModel.fromMap(Map<String, dynamic> map) {
    return UploadTemplateImagesResponseModel(
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      count: map['count'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UploadTemplateImagesResponseModel.fromJson(String source) =>
      UploadTemplateImagesResponseModel.fromMap(json.decode(source));

  UploadTemplateImagesResponse toEntity() {
    return UploadTemplateImagesResponse(imageUrls: imageUrls, count: count);
  }

  @override
  List<Object?> get props => [imageUrls, count];
}
