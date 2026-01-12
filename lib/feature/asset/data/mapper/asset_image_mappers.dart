import 'package:sigma_track/feature/asset/data/models/asset_image_model.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_image.dart';

extension AssetImageModelMapper on AssetImageModel {
  AssetImage toEntity() {
    return AssetImage(
      id: id,
      imageUrl: imageUrl,
      displayOrder: displayOrder,
      isPrimary: isPrimary,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension AssetImageEntityMapper on AssetImage {
  AssetImageModel toModel() {
    return AssetImageModel(
      id: id,
      imageUrl: imageUrl,
      displayOrder: displayOrder,
      isPrimary: isPrimary,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
