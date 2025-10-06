import 'package:sigma_track/feature/asset/data/mapper/asset_mappers.dart';
import 'package:sigma_track/feature/maintenance/data/mapper/maintenance_schedule_mappers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record_statistics.dart';
import 'package:sigma_track/feature/maintenance/data/models/maintenance_record_model.dart';
import 'package:sigma_track/feature/maintenance/data/models/maintenance_record_statistics_model.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';

extension MaintenanceRecordTranslationModelMapper
    on MaintenanceRecordTranslationModel {
  MaintenanceRecordTranslation toEntity() {
    return MaintenanceRecordTranslation(
      langCode: langCode,
      title: title,
      notes: notes,
    );
  }
}

extension MaintenanceRecordTranslationEntityMapper
    on MaintenanceRecordTranslation {
  MaintenanceRecordTranslationModel toModel() {
    return MaintenanceRecordTranslationModel(
      langCode: langCode,
      title: title,
      notes: notes,
    );
  }
}

extension MaintenanceRecordModelMapper on MaintenanceRecordModel {
  MaintenanceRecord toEntity() {
    return MaintenanceRecord(
      id: id,
      scheduleId: scheduleId,
      assetId: assetId,
      maintenanceDate: maintenanceDate,
      performedByUserId: performedByUserId,
      performedByVendor: performedByVendor,
      actualCost: actualCost,
      title: title,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations: translations?.map((x) => x.toEntity()).toList() ?? [],
      schedule: schedule?.toEntity(),
      asset: asset.toEntity(),
      performedByUser: performedByUser?.toEntity(),
    );
  }
}

extension MaintenanceRecordEntityMapper on MaintenanceRecord {
  MaintenanceRecordModel toModel() {
    return MaintenanceRecordModel(
      id: id,
      scheduleId: scheduleId,
      assetId: assetId,
      maintenanceDate: maintenanceDate,
      performedByUserId: performedByUserId,
      performedByVendor: performedByVendor,
      actualCost: actualCost,
      title: title,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations: translations?.map((x) => x.toModel()).toList() ?? [],
      schedule: schedule?.toModel(),
      asset: asset.toModel(),
      performedByUser: performedByUser?.toModel(),
    );
  }
}

extension MaintenanceRecordStatisticsModelMapper
    on MaintenanceRecordStatisticsModel {
  MaintenanceRecordStatistics toEntity() {
    return MaintenanceRecordStatistics(
      total: total.toEntity(),
      byPerformer: byPerformer.map((x) => x.toEntity()).toList(),
      byVendor: byVendor.map((x) => x.toEntity()).toList(),
      byAsset: byAsset.map((x) => x.toEntity()).toList(),
      costStatistics: costStatistics.toEntity(),
      completionTrend: completionTrend.map((x) => x.toEntity()).toList(),
      monthlyTrends: monthlyTrends.map((x) => x.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

extension MaintenanceRecordStatisticsEntityMapper
    on MaintenanceRecordStatistics {
  MaintenanceRecordStatisticsModel toModel() {
    return MaintenanceRecordStatisticsModel(
      total: total.toModel(),
      byPerformer: byPerformer.map((x) => x.toModel()).toList(),
      byVendor: byVendor.map((x) => x.toModel()).toList(),
      byAsset: byAsset.map((x) => x.toModel()).toList(),
      costStatistics: costStatistics.toModel(),
      completionTrend: completionTrend.map((x) => x.toModel()).toList(),
      monthlyTrends: monthlyTrends.map((x) => x.toModel()).toList(),
      summary: summary.toModel(),
    );
  }
}

extension MaintenanceRecordCountStatisticsModelMapper
    on MaintenanceRecordCountStatisticsModel {
  MaintenanceRecordCountStatistics toEntity() {
    return MaintenanceRecordCountStatistics(count: count);
  }
}

extension MaintenanceRecordCountStatisticsEntityMapper
    on MaintenanceRecordCountStatistics {
  MaintenanceRecordCountStatisticsModel toModel() {
    return MaintenanceRecordCountStatisticsModel(count: count);
  }
}

extension UserMaintenanceRecordStatisticsModelMapper
    on UserMaintenanceRecordStatisticsModel {
  UserMaintenanceRecordStatistics toEntity() {
    return UserMaintenanceRecordStatistics(
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      count: count,
      totalCost: totalCost,
      averageCost: averageCost,
    );
  }
}

extension UserMaintenanceRecordStatisticsEntityMapper
    on UserMaintenanceRecordStatistics {
  UserMaintenanceRecordStatisticsModel toModel() {
    return UserMaintenanceRecordStatisticsModel(
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      count: count,
      totalCost: totalCost,
      averageCost: averageCost,
    );
  }
}

extension VendorMaintenanceRecordStatisticsModelMapper
    on VendorMaintenanceRecordStatisticsModel {
  VendorMaintenanceRecordStatistics toEntity() {
    return VendorMaintenanceRecordStatistics(
      vendorName: vendorName,
      count: count,
      totalCost: totalCost,
      averageCost: averageCost,
    );
  }
}

extension VendorMaintenanceRecordStatisticsEntityMapper
    on VendorMaintenanceRecordStatistics {
  VendorMaintenanceRecordStatisticsModel toModel() {
    return VendorMaintenanceRecordStatisticsModel(
      vendorName: vendorName,
      count: count,
      totalCost: totalCost,
      averageCost: averageCost,
    );
  }
}

extension AssetMaintenanceRecordStatisticsModelMapper
    on AssetMaintenanceRecordStatisticsModel {
  AssetMaintenanceRecordStatistics toEntity() {
    return AssetMaintenanceRecordStatistics(
      assetId: assetId,
      assetName: assetName,
      assetTag: assetTag,
      recordCount: recordCount,
      lastMaintenance: lastMaintenance,
      totalCost: totalCost,
      averageCost: averageCost,
    );
  }
}

extension AssetMaintenanceRecordStatisticsEntityMapper
    on AssetMaintenanceRecordStatistics {
  AssetMaintenanceRecordStatisticsModel toModel() {
    return AssetMaintenanceRecordStatisticsModel(
      assetId: assetId,
      assetName: assetName,
      assetTag: assetTag,
      recordCount: recordCount,
      lastMaintenance: lastMaintenance,
      totalCost: totalCost,
      averageCost: averageCost,
    );
  }
}

extension MaintenanceRecordCostStatisticsModelMapper
    on MaintenanceRecordCostStatisticsModel {
  MaintenanceRecordCostStatistics toEntity() {
    return MaintenanceRecordCostStatistics(
      totalCost: totalCost,
      averageCost: averageCost,
      minCost: minCost,
      maxCost: maxCost,
      recordsWithCost: recordsWithCost,
      recordsWithoutCost: recordsWithoutCost,
    );
  }
}

extension MaintenanceRecordCostStatisticsEntityMapper
    on MaintenanceRecordCostStatistics {
  MaintenanceRecordCostStatisticsModel toModel() {
    return MaintenanceRecordCostStatisticsModel(
      totalCost: totalCost,
      averageCost: averageCost,
      minCost: minCost,
      maxCost: maxCost,
      recordsWithCost: recordsWithCost,
      recordsWithoutCost: recordsWithoutCost,
    );
  }
}

extension MaintenanceRecordCompletionTrendModelMapper
    on MaintenanceRecordCompletionTrendModel {
  MaintenanceRecordCompletionTrend toEntity() {
    return MaintenanceRecordCompletionTrend(date: date, count: count);
  }
}

extension MaintenanceRecordCompletionTrendEntityMapper
    on MaintenanceRecordCompletionTrend {
  MaintenanceRecordCompletionTrendModel toModel() {
    return MaintenanceRecordCompletionTrendModel(date: date, count: count);
  }
}

extension MaintenanceRecordMonthlyTrendModelMapper
    on MaintenanceRecordMonthlyTrendModel {
  MaintenanceRecordMonthlyTrend toEntity() {
    return MaintenanceRecordMonthlyTrend(
      month: month,
      recordCount: recordCount,
      totalCost: totalCost,
    );
  }
}

extension MaintenanceRecordMonthlyTrendEntityMapper
    on MaintenanceRecordMonthlyTrend {
  MaintenanceRecordMonthlyTrendModel toModel() {
    return MaintenanceRecordMonthlyTrendModel(
      month: month,
      recordCount: recordCount,
      totalCost: totalCost,
    );
  }
}

extension MaintenanceRecordSummaryStatisticsModelMapper
    on MaintenanceRecordSummaryStatisticsModel {
  MaintenanceRecordSummaryStatistics toEntity() {
    return MaintenanceRecordSummaryStatistics(
      totalRecords: totalRecords,
      recordsWithCostInfo: recordsWithCostInfo,
      costInfoPercentage: costInfoPercentage,
      totalUniqueVendors: totalUniqueVendors,
      totalUniquePerformers: totalUniquePerformers,
      averageRecordsPerDay: averageRecordsPerDay,
      latestRecordDate: latestRecordDate,
      earliestRecordDate: earliestRecordDate,
      mostExpensiveMaintenanceCost: mostExpensiveMaintenanceCost,
      leastExpensiveMaintenanceCost: leastExpensiveMaintenanceCost,
      assetsWithMaintenance: assetsWithMaintenance,
      averageMaintenancePerAsset: averageMaintenancePerAsset,
    );
  }
}

extension MaintenanceRecordSummaryStatisticsEntityMapper
    on MaintenanceRecordSummaryStatistics {
  MaintenanceRecordSummaryStatisticsModel toModel() {
    return MaintenanceRecordSummaryStatisticsModel(
      totalRecords: totalRecords,
      recordsWithCostInfo: recordsWithCostInfo,
      costInfoPercentage: costInfoPercentage,
      totalUniqueVendors: totalUniqueVendors,
      totalUniquePerformers: totalUniquePerformers,
      averageRecordsPerDay: averageRecordsPerDay,
      latestRecordDate: latestRecordDate,
      earliestRecordDate: earliestRecordDate,
      mostExpensiveMaintenanceCost: mostExpensiveMaintenanceCost,
      leastExpensiveMaintenanceCost: leastExpensiveMaintenanceCost,
      assetsWithMaintenance: assetsWithMaintenance,
      averageMaintenancePerAsset: averageMaintenancePerAsset,
    );
  }
}
