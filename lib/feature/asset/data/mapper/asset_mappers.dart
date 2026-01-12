import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_statistics.dart';
import 'package:sigma_track/feature/asset/data/models/asset_statistics_model.dart';
import 'package:sigma_track/feature/asset/domain/entities/generate_asset_tag_response.dart';
import 'package:sigma_track/feature/asset/data/models/generate_asset_tag_response_model.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_template_images_response.dart';
import 'package:sigma_track/feature/asset/data/models/upload_template_images_response_model.dart';
import 'package:sigma_track/feature/asset/domain/entities/image_response.dart';
import 'package:sigma_track/feature/asset/data/models/image_response_model.dart';
import 'package:sigma_track/feature/category/data/mapper/category_mappers.dart';
import 'package:sigma_track/feature/location/data/mapper/location_mappers.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';

extension AssetModelMapper on AssetModel {
  Asset toEntity() {
    return Asset(
      id: id,
      assetTag: assetTag,
      dataMatrixImageUrl: dataMatrixImageUrl,
      assetName: assetName,
      categoryId: categoryId,
      brand: brand,
      model: model,
      serialNumber: serialNumber,
      purchaseDate: purchaseDate,
      purchasePrice: purchasePrice,
      vendorName: vendorName,
      warrantyEnd: warrantyEnd,
      status: status,
      condition: condition,
      locationId: locationId,
      assignedToId: assignedToId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      category: category?.toEntity(),
      location: location?.toEntity(),
      assignedTo: assignedTo?.toEntity(),
    );
  }
}

extension AssetEntityMapper on Asset {
  AssetModel toModel() {
    return AssetModel(
      id: id,
      assetTag: assetTag,
      dataMatrixImageUrl: dataMatrixImageUrl,
      assetName: assetName,
      categoryId: categoryId,
      brand: brand,
      model: model,
      serialNumber: serialNumber,
      purchaseDate: purchaseDate,
      purchasePrice: purchasePrice,
      vendorName: vendorName,
      warrantyEnd: warrantyEnd,
      status: status,
      condition: condition,
      locationId: locationId,
      assignedToId: assignedToId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      category: category?.toModel(),
      location: location?.toModel(),
      assignedTo: assignedTo?.toModel(),
    );
  }
}

extension AssetStatisticsModelMapper on AssetStatisticsModel {
  AssetStatistics toEntity() {
    return AssetStatistics(
      total: total.toEntity(),
      byStatus: byStatus.toEntity(),
      byCondition: byCondition.toEntity(),
      byCategory: byCategory.map((model) => model.toEntity()).toList(),
      byLocation: byLocation.map((model) => model.toEntity()).toList(),
      byAssignment: byAssignment.toEntity(),
      valueStatistics: valueStatistics.toEntity(),
      warrantyStatistics: warrantyStatistics.toEntity(),
      creationTrends: creationTrends.map((model) => model.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

extension AssetStatisticsEntityMapper on AssetStatistics {
  AssetStatisticsModel toModel() {
    return AssetStatisticsModel(
      total: total.toModel(),
      byStatus: byStatus.toModel(),
      byCondition: byCondition.toModel(),
      byCategory: byCategory.map((entity) => entity.toModel()).toList(),
      byLocation: byLocation.map((entity) => entity.toModel()).toList(),
      byAssignment: byAssignment.toModel(),
      valueStatistics: valueStatistics.toModel(),
      warrantyStatistics: warrantyStatistics.toModel(),
      creationTrends: creationTrends.map((entity) => entity.toModel()).toList(),
      summary: summary.toModel(),
    );
  }
}

extension AssetCountStatisticsModelMapper on AssetCountStatisticsModel {
  AssetCountStatistics toEntity() => AssetCountStatistics(count: count);
}

extension AssetCountStatisticsEntityMapper on AssetCountStatistics {
  AssetCountStatisticsModel toModel() =>
      AssetCountStatisticsModel(count: count);
}

extension AssetStatusStatisticsModelMapper on AssetStatusStatisticsModel {
  AssetStatusStatistics toEntity() => AssetStatusStatistics(
    active: active,
    maintenance: maintenance,
    disposed: disposed,
    lost: lost,
  );
}

extension AssetStatusStatisticsEntityMapper on AssetStatusStatistics {
  AssetStatusStatisticsModel toModel() => AssetStatusStatisticsModel(
    active: active,
    maintenance: maintenance,
    disposed: disposed,
    lost: lost,
  );
}

extension AssetConditionStatisticsModelMapper on AssetConditionStatisticsModel {
  AssetConditionStatistics toEntity() => AssetConditionStatistics(
    good: good,
    fair: fair,
    poor: poor,
    damaged: damaged,
  );
}

extension AssetConditionStatisticsEntityMapper on AssetConditionStatistics {
  AssetConditionStatisticsModel toModel() => AssetConditionStatisticsModel(
    good: good,
    fair: fair,
    poor: poor,
    damaged: damaged,
  );
}

extension AssetAssignmentStatisticsModelMapper
    on AssetAssignmentStatisticsModel {
  AssetAssignmentStatistics toEntity() =>
      AssetAssignmentStatistics(assigned: assigned, unassigned: unassigned);
}

extension AssetAssignmentStatisticsEntityMapper on AssetAssignmentStatistics {
  AssetAssignmentStatisticsModel toModel() => AssetAssignmentStatisticsModel(
    assigned: assigned,
    unassigned: unassigned,
  );
}

extension AssetValueStatisticsModelMapper on AssetValueStatisticsModel {
  AssetValueStatistics toEntity() => AssetValueStatistics(
    totalValue: totalValue,
    averageValue: averageValue,
    minValue: minValue,
    maxValue: maxValue,
    assetsWithValue: assetsWithValue,
    assetsWithoutValue: assetsWithoutValue,
  );
}

extension AssetValueStatisticsEntityMapper on AssetValueStatistics {
  AssetValueStatisticsModel toModel() => AssetValueStatisticsModel(
    totalValue: totalValue,
    averageValue: averageValue,
    minValue: minValue,
    maxValue: maxValue,
    assetsWithValue: assetsWithValue,
    assetsWithoutValue: assetsWithoutValue,
  );
}

extension AssetWarrantyStatisticsModelMapper on AssetWarrantyStatisticsModel {
  AssetWarrantyStatistics toEntity() => AssetWarrantyStatistics(
    activeWarranties: activeWarranties,
    expiredWarranties: expiredWarranties,
    noWarrantyInfo: noWarrantyInfo,
  );
}

extension AssetWarrantyStatisticsEntityMapper on AssetWarrantyStatistics {
  AssetWarrantyStatisticsModel toModel() => AssetWarrantyStatisticsModel(
    activeWarranties: activeWarranties,
    expiredWarranties: expiredWarranties,
    noWarrantyInfo: noWarrantyInfo,
  );
}

extension AssetCreationTrendModelMapper on AssetCreationTrendModel {
  AssetCreationTrend toEntity() =>
      AssetCreationTrend(date: DateTime.parse(date), count: count);
}

extension AssetCreationTrendEntityMapper on AssetCreationTrend {
  AssetCreationTrendModel toModel() =>
      AssetCreationTrendModel(date: date.toIso8601String(), count: count);
}

extension AssetSummaryStatisticsModelMapper on AssetSummaryStatisticsModel {
  AssetSummaryStatistics toEntity() => AssetSummaryStatistics(
    totalAssets: totalAssets,
    activeAssetsPercentage: activeAssetsPercentage,
    maintenanceAssetsPercentage: maintenanceAssetsPercentage,
    disposedAssetsPercentage: disposedAssetsPercentage,
    lostAssetsPercentage: lostAssetsPercentage,
    goodConditionPercentage: goodConditionPercentage,
    fairConditionPercentage: fairConditionPercentage,
    poorConditionPercentage: poorConditionPercentage,
    damagedConditionPercentage: damagedConditionPercentage,
    assignedAssetsPercentage: assignedAssetsPercentage,
    unassignedAssetsPercentage: unassignedAssetsPercentage,
    assetsWithPurchasePrice: assetsWithPurchasePrice,
    purchasePricePercentage: purchasePricePercentage,
    assetsWithDataMatrix: assetsWithDataMatrix,
    dataMatrixPercentage: dataMatrixPercentage,
    assetsWithWarranty: assetsWithWarranty,
    warrantyPercentage: warrantyPercentage,
    totalCategories: totalCategories,
    totalLocations: totalLocations,
    averageAssetsPerDay: averageAssetsPerDay,
    latestCreationDate: DateTime.parse(latestCreationDate),
    earliestCreationDate: DateTime.parse(earliestCreationDate),
    mostExpensiveAssetValue: mostExpensiveAssetValue,
    leastExpensiveAssetValue: leastExpensiveAssetValue,
  );
}

extension AssetSummaryStatisticsEntityMapper on AssetSummaryStatistics {
  AssetSummaryStatisticsModel toModel() => AssetSummaryStatisticsModel(
    totalAssets: totalAssets,
    activeAssetsPercentage: activeAssetsPercentage,
    maintenanceAssetsPercentage: maintenanceAssetsPercentage,
    disposedAssetsPercentage: disposedAssetsPercentage,
    lostAssetsPercentage: lostAssetsPercentage,
    goodConditionPercentage: goodConditionPercentage,
    fairConditionPercentage: fairConditionPercentage,
    poorConditionPercentage: poorConditionPercentage,
    damagedConditionPercentage: damagedConditionPercentage,
    assignedAssetsPercentage: assignedAssetsPercentage,
    unassignedAssetsPercentage: unassignedAssetsPercentage,
    assetsWithPurchasePrice: assetsWithPurchasePrice,
    purchasePricePercentage: purchasePricePercentage,
    assetsWithDataMatrix: assetsWithDataMatrix,
    dataMatrixPercentage: dataMatrixPercentage,
    assetsWithWarranty: assetsWithWarranty,
    warrantyPercentage: warrantyPercentage,
    totalCategories: totalCategories,
    totalLocations: totalLocations,
    averageAssetsPerDay: averageAssetsPerDay,
    latestCreationDate: latestCreationDate.toIso8601String(),
    earliestCreationDate: earliestCreationDate.toIso8601String(),
    mostExpensiveAssetValue: mostExpensiveAssetValue,
    leastExpensiveAssetValue: leastExpensiveAssetValue,
  );
}

extension GenerateAssetTagResponseModelMapper on GenerateAssetTagResponseModel {
  GenerateAssetTagResponse toEntity() {
    return GenerateAssetTagResponse(
      categoryCode: categoryCode,
      lastAssetTag: lastAssetTag,
      suggestedTag: suggestedTag,
      nextIncrement: nextIncrement,
    );
  }
}

extension GenerateAssetTagResponseEntityMapper on GenerateAssetTagResponse {
  GenerateAssetTagResponseModel toModel() {
    return GenerateAssetTagResponseModel(
      categoryCode: categoryCode,
      lastAssetTag: lastAssetTag,
      suggestedTag: suggestedTag,
      nextIncrement: nextIncrement,
    );
  }
}

extension CategoryStatisticsModelMapper on CategoryStatisticsModel {
  CategoryStatistics toEntity() => CategoryStatistics(
    categoryId: categoryId,
    categoryName: categoryName,
    categoryCode: categoryCode,
    assetCount: assetCount,
    percentage: percentage,
  );
}

extension CategoryStatisticsEntityMapper on CategoryStatistics {
  CategoryStatisticsModel toModel() => CategoryStatisticsModel(
    categoryId: categoryId,
    categoryName: categoryName,
    categoryCode: categoryCode,
    assetCount: assetCount,
    percentage: percentage,
  );
}

extension LocationStatisticsModelMapper on LocationStatisticsModel {
  LocationStatistics toEntity() => LocationStatistics(
    locationId: locationId,
    locationName: locationName,
    locationCode: locationCode,
    assetCount: assetCount,
    percentage: percentage,
  );
}

extension LocationStatisticsEntityMapper on LocationStatistics {
  LocationStatisticsModel toModel() => LocationStatisticsModel(
    locationId: locationId,
    locationName: locationName,
    locationCode: locationCode,
    assetCount: assetCount,
    percentage: percentage,
  );
}

extension UploadTemplateImagesResponseModelMapper
    on UploadTemplateImagesResponseModel {
  UploadTemplateImagesResponse toEntity() {
    return UploadTemplateImagesResponse(imageUrls: imageUrls, count: count);
  }
}

extension UploadTemplateImagesResponseEntityMapper
    on UploadTemplateImagesResponse {
  UploadTemplateImagesResponseModel toModel() {
    return UploadTemplateImagesResponseModel(
      imageUrls: imageUrls,
      count: count,
    );
  }
}

extension ImageResponseModelMapper on ImageResponseModel {
  ImageResponse toEntity() {
    return ImageResponse(
      id: id,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
