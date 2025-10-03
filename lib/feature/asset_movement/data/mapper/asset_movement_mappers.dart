import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/data/models/asset_movement_model.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement_statistics.dart';
import 'package:sigma_track/feature/asset_movement/data/models/asset_movement_statistics_model.dart';
import 'package:sigma_track/feature/asset/data/mapper/asset_mappers.dart';
import 'package:sigma_track/feature/location/data/mapper/location_mappers.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';

extension AssetMovementTranslationModelMapper on AssetMovementTranslationModel {
  AssetMovementTranslation toEntity() {
    return AssetMovementTranslation(langCode: langCode, notes: notes);
  }
}

extension AssetMovementTranslationEntityMapper on AssetMovementTranslation {
  AssetMovementTranslationModel toModel() {
    return AssetMovementTranslationModel(langCode: langCode, notes: notes);
  }
}

extension AssetMovementModelMapper on AssetMovementModel {
  AssetMovement toEntity() {
    return AssetMovement(
      id: id,
      assetId: assetId,
      fromLocationId: fromLocationId,
      toLocationId: toLocationId,
      fromUserId: fromUserId,
      toUserId: toUserId,
      movedById: movedById,
      movementDate: movementDate,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations: translations.map((model) => model.toEntity()).toList(),
      asset: asset.toEntity(),
      fromLocation: fromLocation?.toEntity(),
      toLocation: toLocation?.toEntity(),
      fromUser: fromUser?.toEntity(),
      toUser: toUser?.toEntity(),
      movedBy: movedBy.toEntity(),
    );
  }
}

extension AssetMovementEntityMapper on AssetMovement {
  AssetMovementModel toModel() {
    return AssetMovementModel(
      id: id,
      assetId: assetId,
      fromLocationId: fromLocationId,
      toLocationId: toLocationId,
      fromUserId: fromUserId,
      toUserId: toUserId,
      movedById: movedById,
      movementDate: movementDate,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations: translations.map((entity) => entity.toModel()).toList(),
      asset: asset.toModel(),
      fromLocation: fromLocation?.toModel(),
      toLocation: toLocation?.toModel(),
      fromUser: fromUser?.toModel(),
      toUser: toUser?.toModel(),
      movedBy: movedBy.toModel(),
    );
  }
}

extension AssetMovementStatisticsModelMapper on AssetMovementStatisticsModel {
  AssetMovementStatistics toEntity() {
    return AssetMovementStatistics(
      total: total.toEntity(),
      byAsset: byAsset.map((model) => model.toEntity()).toList(),
      byLocation: byLocation.map((model) => model.toEntity()).toList(),
      byUser: byUser.map((model) => model.toEntity()).toList(),
      byMovementType: byMovementType.toEntity(),
      recentMovements: recentMovements
          .map((model) => model.toEntity())
          .toList(),
      movementTrends: movementTrends.map((model) => model.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

extension AssetMovementStatisticsEntityMapper on AssetMovementStatistics {
  AssetMovementStatisticsModel toModel() {
    return AssetMovementStatisticsModel(
      total: total.toModel(),
      byAsset: byAsset.map((entity) => entity.toModel()).toList(),
      byLocation: byLocation.map((entity) => entity.toModel()).toList(),
      byUser: byUser.map((entity) => entity.toModel()).toList(),
      byMovementType: byMovementType.toModel(),
      recentMovements: recentMovements
          .map((entity) => entity.toModel())
          .toList(),
      movementTrends: movementTrends.map((entity) => entity.toModel()).toList(),
      summary: summary.toModel(),
    );
  }
}

extension AssetMovementCountStatisticsModelMapper
    on AssetMovementCountStatisticsModel {
  AssetMovementCountStatistics toEntity() =>
      AssetMovementCountStatistics(count: count);
}

extension AssetMovementCountStatisticsEntityMapper
    on AssetMovementCountStatistics {
  AssetMovementCountStatisticsModel toModel() =>
      AssetMovementCountStatisticsModel(count: count);
}

extension AssetMovementByAssetStatsModelMapper
    on AssetMovementByAssetStatsModel {
  AssetMovementByAssetStats toEntity() => AssetMovementByAssetStats(
    assetId: assetId,
    assetTag: assetTag,
    assetName: assetName,
    movementCount: movementCount,
  );
}

extension AssetMovementByAssetStatsEntityMapper on AssetMovementByAssetStats {
  AssetMovementByAssetStatsModel toModel() => AssetMovementByAssetStatsModel(
    assetId: assetId,
    assetTag: assetTag,
    assetName: assetName,
    movementCount: movementCount,
  );
}

extension AssetMovementByLocationStatsModelMapper
    on AssetMovementByLocationStatsModel {
  AssetMovementByLocationStats toEntity() => AssetMovementByLocationStats(
    locationId: locationId,
    locationCode: locationCode,
    locationName: locationName,
    incomingCount: incomingCount,
    outgoingCount: outgoingCount,
    netMovement: netMovement,
  );
}

extension AssetMovementByLocationStatsEntityMapper
    on AssetMovementByLocationStats {
  AssetMovementByLocationStatsModel toModel() =>
      AssetMovementByLocationStatsModel(
        locationId: locationId,
        locationCode: locationCode,
        locationName: locationName,
        incomingCount: incomingCount,
        outgoingCount: outgoingCount,
        netMovement: netMovement,
      );
}

extension AssetMovementByUserStatsModelMapper on AssetMovementByUserStatsModel {
  AssetMovementByUserStats toEntity() => AssetMovementByUserStats(
    userId: userId,
    userName: userName,
    movementCount: movementCount,
  );
}

extension AssetMovementByUserStatsEntityMapper on AssetMovementByUserStats {
  AssetMovementByUserStatsModel toModel() => AssetMovementByUserStatsModel(
    userId: userId,
    userName: userName,
    movementCount: movementCount,
  );
}

extension AssetMovementTypeStatisticsModelMapper
    on AssetMovementTypeStatisticsModel {
  AssetMovementTypeStatistics toEntity() => AssetMovementTypeStatistics(
    locationToLocation: locationToLocation,
    locationToUser: locationToUser,
    userToLocation: userToLocation,
    userToUser: userToUser,
    newAsset: newAsset,
  );
}

extension AssetMovementTypeStatisticsEntityMapper
    on AssetMovementTypeStatistics {
  AssetMovementTypeStatisticsModel toModel() =>
      AssetMovementTypeStatisticsModel(
        locationToLocation: locationToLocation,
        locationToUser: locationToUser,
        userToLocation: userToLocation,
        userToUser: userToUser,
        newAsset: newAsset,
      );
}

extension AssetMovementRecentStatsModelMapper on AssetMovementRecentStatsModel {
  AssetMovementRecentStats toEntity() => AssetMovementRecentStats(
    id: id,
    assetTag: assetTag,
    assetName: assetName,
    fromLocation: fromLocation,
    toLocation: toLocation,
    fromUser: fromUser,
    toUser: toUser,
    movedBy: movedBy,
    movementDate: movementDate,
    movementType: movementType,
  );
}

extension AssetMovementRecentStatsEntityMapper on AssetMovementRecentStats {
  AssetMovementRecentStatsModel toModel() => AssetMovementRecentStatsModel(
    id: id,
    assetTag: assetTag,
    assetName: assetName,
    fromLocation: fromLocation,
    toLocation: toLocation,
    fromUser: fromUser,
    toUser: toUser,
    movedBy: movedBy,
    movementDate: movementDate,
    movementType: movementType,
  );
}

extension AssetMovementTrendModelMapper on AssetMovementTrendModel {
  AssetMovementTrend toEntity() =>
      AssetMovementTrend(date: DateTime.parse(date), count: count);
}

extension AssetMovementTrendEntityMapper on AssetMovementTrend {
  AssetMovementTrendModel toModel() =>
      AssetMovementTrendModel(date: date.toIso8601String(), count: count);
}

extension AssetMovementSummaryStatisticsModelMapper
    on AssetMovementSummaryStatisticsModel {
  AssetMovementSummaryStatistics toEntity() => AssetMovementSummaryStatistics(
    totalMovements: totalMovements,
    movementsToday: movementsToday,
    movementsThisWeek: movementsThisWeek,
    movementsThisMonth: movementsThisMonth,
    mostActiveAsset: mostActiveAsset,
    mostActiveLocation: mostActiveLocation,
    mostActiveUser: mostActiveUser,
    averageMovementsPerDay: averageMovementsPerDay,
    averageMovementsPerAsset: averageMovementsPerAsset,
    latestMovementDate: latestMovementDate,
    earliestMovementDate: earliestMovementDate,
    uniqueAssetsWithMovements: uniqueAssetsWithMovements,
    uniqueLocationsInvolved: uniqueLocationsInvolved,
    uniqueUsersInvolved: uniqueUsersInvolved,
  );
}

extension AssetMovementSummaryStatisticsEntityMapper
    on AssetMovementSummaryStatistics {
  AssetMovementSummaryStatisticsModel toModel() =>
      AssetMovementSummaryStatisticsModel(
        totalMovements: totalMovements,
        movementsToday: movementsToday,
        movementsThisWeek: movementsThisWeek,
        movementsThisMonth: movementsThisMonth,
        mostActiveAsset: mostActiveAsset,
        mostActiveLocation: mostActiveLocation,
        mostActiveUser: mostActiveUser,
        averageMovementsPerDay: averageMovementsPerDay,
        averageMovementsPerAsset: averageMovementsPerAsset,
        latestMovementDate: latestMovementDate,
        earliestMovementDate: earliestMovementDate,
        uniqueAssetsWithMovements: uniqueAssetsWithMovements,
        uniqueLocationsInvolved: uniqueLocationsInvolved,
        uniqueUsersInvolved: uniqueUsersInvolved,
      );
}
