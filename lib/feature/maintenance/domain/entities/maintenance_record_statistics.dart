import 'package:equatable/equatable.dart';

class MaintenanceRecordStatistics extends Equatable {
  final MaintenanceRecordCountStatistics total;
  final List<UserMaintenanceRecordStatistics> byPerformer;
  final List<VendorMaintenanceRecordStatistics> byVendor;
  final List<AssetMaintenanceRecordStatistics> byAsset;
  final MaintenanceRecordCostStatistics costStatistics;
  final List<MaintenanceRecordCompletionTrend> completionTrend;
  final List<MaintenanceRecordMonthlyTrend> monthlyTrends;
  final MaintenanceRecordSummaryStatistics summary;

  const MaintenanceRecordStatistics({
    required this.total,
    required this.byPerformer,
    required this.byVendor,
    required this.byAsset,
    required this.costStatistics,
    required this.completionTrend,
    required this.monthlyTrends,
    required this.summary,
  });

  @override
  List<Object> get props => [
    total,
    byPerformer,
    byVendor,
    byAsset,
    costStatistics,
    completionTrend,
    monthlyTrends,
    summary,
  ];
}

class MaintenanceRecordCountStatistics extends Equatable {
  final int count;

  const MaintenanceRecordCountStatistics({required this.count});

  @override
  List<Object> get props => [count];
}

class UserMaintenanceRecordStatistics extends Equatable {
  final String userId;
  final String userName;
  final String userEmail;
  final int count;
  final double totalCost;
  final double averageCost;

  const UserMaintenanceRecordStatistics({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.count,
    required this.totalCost,
    required this.averageCost,
  });

  @override
  List<Object> get props => [
    userId,
    userName,
    userEmail,
    count,
    totalCost,
    averageCost,
  ];
}

class VendorMaintenanceRecordStatistics extends Equatable {
  final String vendorName;
  final int count;
  final double totalCost;
  final double averageCost;

  const VendorMaintenanceRecordStatistics({
    required this.vendorName,
    required this.count,
    required this.totalCost,
    required this.averageCost,
  });

  @override
  List<Object> get props => [vendorName, count, totalCost, averageCost];
}

class AssetMaintenanceRecordStatistics extends Equatable {
  final String assetId;
  final String assetName;
  final String assetTag;
  final int recordCount;
  final String lastMaintenance;
  final double totalCost;
  final double averageCost;

  const AssetMaintenanceRecordStatistics({
    required this.assetId,
    required this.assetName,
    required this.assetTag,
    required this.recordCount,
    required this.lastMaintenance,
    required this.totalCost,
    required this.averageCost,
  });

  @override
  List<Object> get props => [
    assetId,
    assetName,
    assetTag,
    recordCount,
    lastMaintenance,
    totalCost,
    averageCost,
  ];
}

class MaintenanceRecordCostStatistics extends Equatable {
  final double? totalCost;
  final double? averageCost;
  final double? minCost;
  final double? maxCost;
  final int recordsWithCost;
  final int recordsWithoutCost;

  const MaintenanceRecordCostStatistics({
    this.totalCost,
    this.averageCost,
    this.minCost,
    this.maxCost,
    required this.recordsWithCost,
    required this.recordsWithoutCost,
  });

  @override
  List<Object?> get props => [
    totalCost,
    averageCost,
    minCost,
    maxCost,
    recordsWithCost,
    recordsWithoutCost,
  ];
}

class MaintenanceRecordCompletionTrend extends Equatable {
  final DateTime date;
  final int count;

  const MaintenanceRecordCompletionTrend({
    required this.date,
    required this.count,
  });

  @override
  List<Object> get props => [date, count];
}

class MaintenanceRecordMonthlyTrend extends Equatable {
  final String month;
  final int recordCount;
  final double totalCost;

  const MaintenanceRecordMonthlyTrend({
    required this.month,
    required this.recordCount,
    required this.totalCost,
  });

  @override
  List<Object> get props => [month, recordCount, totalCost];
}

class MaintenanceRecordSummaryStatistics extends Equatable {
  final int totalRecords;
  final int recordsWithCostInfo;
  final double costInfoPercentage;
  final int totalUniqueVendors;
  final int totalUniquePerformers;
  final double averageRecordsPerDay;
  final DateTime latestRecordDate;
  final DateTime earliestRecordDate;
  final double? mostExpensiveMaintenanceCost;
  final double? leastExpensiveMaintenanceCost;
  final int assetsWithMaintenance;
  final double averageMaintenancePerAsset;

  const MaintenanceRecordSummaryStatistics({
    required this.totalRecords,
    required this.recordsWithCostInfo,
    required this.costInfoPercentage,
    required this.totalUniqueVendors,
    required this.totalUniquePerformers,
    required this.averageRecordsPerDay,
    required this.latestRecordDate,
    required this.earliestRecordDate,
    this.mostExpensiveMaintenanceCost,
    this.leastExpensiveMaintenanceCost,
    required this.assetsWithMaintenance,
    required this.averageMaintenancePerAsset,
  });

  @override
  List<Object?> get props => [
    totalRecords,
    recordsWithCostInfo,
    costInfoPercentage,
    totalUniqueVendors,
    totalUniquePerformers,
    averageRecordsPerDay,
    latestRecordDate,
    earliestRecordDate,
    mostExpensiveMaintenanceCost,
    leastExpensiveMaintenanceCost,
    assetsWithMaintenance,
    averageMaintenancePerAsset,
  ];
}
