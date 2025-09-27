import 'package:equatable/equatable.dart';
import 'package:sigma_track/feature/category/domain/entities/category_statistics.dart';
import 'package:sigma_track/feature/location/domain/entities/location_statistics.dart';

class AssetStatistics extends Equatable {
  final AssetCountStatistics total;
  final AssetStatusStatistics byStatus;
  final AssetConditionStatistics byCondition;
  final List<CategoryStatistics> byCategory;
  final List<LocationStatistics> byLocation;
  final AssetAssignmentStatistics byAssignment;
  final AssetValueStatistics valueStatistics;
  final AssetWarrantyStatistics warrantyStatistics;
  final List<AssetCreationTrend> creationTrends;
  final AssetSummaryStatistics summary;

  const AssetStatistics({
    required this.total,
    required this.byStatus,
    required this.byCondition,
    required this.byCategory,
    required this.byLocation,
    required this.byAssignment,
    required this.valueStatistics,
    required this.warrantyStatistics,
    required this.creationTrends,
    required this.summary,
  });

  @override
  List<Object> get props => [
    total,
    byStatus,
    byCondition,
    byCategory,
    byLocation,
    byAssignment,
    valueStatistics,
    warrantyStatistics,
    creationTrends,
    summary,
  ];
}

class AssetCountStatistics extends Equatable {
  final int count;

  const AssetCountStatistics({required this.count});

  @override
  List<Object> get props => [count];
}

class AssetStatusStatistics extends Equatable {
  final int active;
  final int maintenance;
  final int disposed;
  final int lost;

  const AssetStatusStatistics({
    required this.active,
    required this.maintenance,
    required this.disposed,
    required this.lost,
  });

  @override
  List<Object> get props => [active, maintenance, disposed, lost];
}

class AssetConditionStatistics extends Equatable {
  final int good;
  final int fair;
  final int poor;
  final int damaged;

  const AssetConditionStatistics({
    required this.good,
    required this.fair,
    required this.poor,
    required this.damaged,
  });

  @override
  List<Object> get props => [good, fair, poor, damaged];
}

class AssetAssignmentStatistics extends Equatable {
  final int assigned;
  final int unassigned;

  const AssetAssignmentStatistics({
    required this.assigned,
    required this.unassigned,
  });

  @override
  List<Object> get props => [assigned, unassigned];
}

class AssetValueStatistics extends Equatable {
  final double? totalValue;
  final double? averageValue;
  final double? minValue;
  final double? maxValue;
  final int assetsWithValue;
  final int assetsWithoutValue;

  const AssetValueStatistics({
    this.totalValue,
    this.averageValue,
    this.minValue,
    this.maxValue,
    required this.assetsWithValue,
    required this.assetsWithoutValue,
  });

  @override
  List<Object?> get props => [
    totalValue,
    averageValue,
    minValue,
    maxValue,
    assetsWithValue,
    assetsWithoutValue,
  ];
}

class AssetWarrantyStatistics extends Equatable {
  final int activeWarranties;
  final int expiredWarranties;
  final int noWarrantyInfo;

  const AssetWarrantyStatistics({
    required this.activeWarranties,
    required this.expiredWarranties,
    required this.noWarrantyInfo,
  });

  @override
  List<Object> get props => [
    activeWarranties,
    expiredWarranties,
    noWarrantyInfo,
  ];
}

class AssetCreationTrend extends Equatable {
  final DateTime date;
  final int count;

  const AssetCreationTrend({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];
}

class AssetSummaryStatistics extends Equatable {
  final int totalAssets;
  final double activeAssetsPercentage;
  final double maintenanceAssetsPercentage;
  final double disposedAssetsPercentage;
  final double lostAssetsPercentage;
  final double goodConditionPercentage;
  final double fairConditionPercentage;
  final double poorConditionPercentage;
  final double damagedConditionPercentage;
  final double assignedAssetsPercentage;
  final double unassignedAssetsPercentage;
  final int assetsWithPurchasePrice;
  final double purchasePricePercentage;
  final int assetsWithDataMatrix;
  final double dataMatrixPercentage;
  final int assetsWithWarranty;
  final double warrantyPercentage;
  final int totalCategories;
  final int totalLocations;
  final double averageAssetsPerDay;
  final DateTime latestCreationDate;
  final DateTime earliestCreationDate;
  final double? mostExpensiveAssetValue;
  final double? leastExpensiveAssetValue;

  const AssetSummaryStatistics({
    required this.totalAssets,
    required this.activeAssetsPercentage,
    required this.maintenanceAssetsPercentage,
    required this.disposedAssetsPercentage,
    required this.lostAssetsPercentage,
    required this.goodConditionPercentage,
    required this.fairConditionPercentage,
    required this.poorConditionPercentage,
    required this.damagedConditionPercentage,
    required this.assignedAssetsPercentage,
    required this.unassignedAssetsPercentage,
    required this.assetsWithPurchasePrice,
    required this.purchasePricePercentage,
    required this.assetsWithDataMatrix,
    required this.dataMatrixPercentage,
    required this.assetsWithWarranty,
    required this.warrantyPercentage,
    required this.totalCategories,
    required this.totalLocations,
    required this.averageAssetsPerDay,
    required this.latestCreationDate,
    required this.earliestCreationDate,
    this.mostExpensiveAssetValue,
    this.leastExpensiveAssetValue,
  });

  @override
  List<Object?> get props => [
    totalAssets,
    activeAssetsPercentage,
    maintenanceAssetsPercentage,
    disposedAssetsPercentage,
    lostAssetsPercentage,
    goodConditionPercentage,
    fairConditionPercentage,
    poorConditionPercentage,
    damagedConditionPercentage,
    assignedAssetsPercentage,
    unassignedAssetsPercentage,
    assetsWithPurchasePrice,
    purchasePricePercentage,
    assetsWithDataMatrix,
    dataMatrixPercentage,
    assetsWithWarranty,
    warrantyPercentage,
    totalCategories,
    totalLocations,
    averageAssetsPerDay,
    latestCreationDate,
    earliestCreationDate,
    mostExpensiveAssetValue,
    leastExpensiveAssetValue,
  ];
}
