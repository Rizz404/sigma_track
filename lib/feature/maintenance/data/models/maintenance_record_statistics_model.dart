import 'dart:convert';

import 'package:equatable/equatable.dart';

class MaintenanceRecordStatisticsModel extends Equatable {
  final MaintenanceRecordCountStatisticsModel total;
  final List<UserMaintenanceRecordStatisticsModel> byPerformer;
  final List<VendorMaintenanceRecordStatisticsModel> byVendor;
  final List<AssetMaintenanceRecordStatisticsModel> byAsset;
  final MaintenanceRecordCostStatisticsModel costStatistics;
  final List<MaintenanceRecordCompletionTrendModel> completionTrend;
  final List<MaintenanceRecordMonthlyTrendModel> monthlyTrends;
  final MaintenanceRecordSummaryStatisticsModel summary;

  const MaintenanceRecordStatisticsModel({
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

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byPerformer': byPerformer.map((x) => x.toMap()).toList(),
      'byVendor': byVendor.map((x) => x.toMap()).toList(),
      'byAsset': byAsset.map((x) => x.toMap()).toList(),
      'costStatistics': costStatistics.toMap(),
      'completionTrend': completionTrend.map((x) => x.toMap()).toList(),
      'monthlyTrends': monthlyTrends.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory MaintenanceRecordStatisticsModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceRecordStatisticsModel(
      total: MaintenanceRecordCountStatisticsModel.fromMap(map['total']),
      byPerformer: List<UserMaintenanceRecordStatisticsModel>.from(
        map['byPerformer']?.map(
          (x) => UserMaintenanceRecordStatisticsModel.fromMap(x),
        ),
      ),
      byVendor: List<VendorMaintenanceRecordStatisticsModel>.from(
        map['byVendor']?.map(
          (x) => VendorMaintenanceRecordStatisticsModel.fromMap(x),
        ),
      ),
      byAsset: List<AssetMaintenanceRecordStatisticsModel>.from(
        map['byAsset']?.map(
          (x) => AssetMaintenanceRecordStatisticsModel.fromMap(x),
        ),
      ),
      costStatistics: MaintenanceRecordCostStatisticsModel.fromMap(
        map['costStatistics'],
      ),
      completionTrend: List<MaintenanceRecordCompletionTrendModel>.from(
        map['completionTrend']?.map(
          (x) => MaintenanceRecordCompletionTrendModel.fromMap(x),
        ),
      ),
      monthlyTrends: List<MaintenanceRecordMonthlyTrendModel>.from(
        map['monthlyTrends']?.map(
          (x) => MaintenanceRecordMonthlyTrendModel.fromMap(x),
        ),
      ),
      summary: MaintenanceRecordSummaryStatisticsModel.fromMap(map['summary']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordStatisticsModel.fromJson(String source) =>
      MaintenanceRecordStatisticsModel.fromMap(json.decode(source));
}

class MaintenanceRecordCountStatisticsModel extends Equatable {
  final int count;

  const MaintenanceRecordCountStatisticsModel({required this.count});

  @override
  List<Object> get props => [count];

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory MaintenanceRecordCountStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceRecordCountStatisticsModel(
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordCountStatisticsModel.fromJson(String source) =>
      MaintenanceRecordCountStatisticsModel.fromMap(json.decode(source));
}

class UserMaintenanceRecordStatisticsModel extends Equatable {
  final String userId;
  final String userName;
  final String userEmail;
  final int count;
  final double totalCost;
  final double averageCost;

  const UserMaintenanceRecordStatisticsModel({
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

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'count': count,
      'totalCost': totalCost,
      'averageCost': averageCost,
    };
  }

  factory UserMaintenanceRecordStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserMaintenanceRecordStatisticsModel(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      count: map['count']?.toInt() ?? 0,
      totalCost: map['totalCost']?.toDouble() ?? 0.0,
      averageCost: map['averageCost']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserMaintenanceRecordStatisticsModel.fromJson(String source) =>
      UserMaintenanceRecordStatisticsModel.fromMap(json.decode(source));
}

class VendorMaintenanceRecordStatisticsModel extends Equatable {
  final String vendorName;
  final int count;
  final double totalCost;
  final double averageCost;

  const VendorMaintenanceRecordStatisticsModel({
    required this.vendorName,
    required this.count,
    required this.totalCost,
    required this.averageCost,
  });

  @override
  List<Object> get props => [vendorName, count, totalCost, averageCost];

  Map<String, dynamic> toMap() {
    return {
      'vendorName': vendorName,
      'count': count,
      'totalCost': totalCost,
      'averageCost': averageCost,
    };
  }

  factory VendorMaintenanceRecordStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return VendorMaintenanceRecordStatisticsModel(
      vendorName: map['vendorName'] ?? '',
      count: map['count']?.toInt() ?? 0,
      totalCost: map['totalCost']?.toDouble() ?? 0.0,
      averageCost: map['averageCost']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory VendorMaintenanceRecordStatisticsModel.fromJson(String source) =>
      VendorMaintenanceRecordStatisticsModel.fromMap(json.decode(source));
}

class AssetMaintenanceRecordStatisticsModel extends Equatable {
  final String assetId;
  final String assetName;
  final String assetTag;
  final int recordCount;
  final String lastMaintenance;
  final double totalCost;
  final double averageCost;

  const AssetMaintenanceRecordStatisticsModel({
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

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'assetName': assetName,
      'assetTag': assetTag,
      'recordCount': recordCount,
      'lastMaintenance': lastMaintenance,
      'totalCost': totalCost,
      'averageCost': averageCost,
    };
  }

  factory AssetMaintenanceRecordStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return AssetMaintenanceRecordStatisticsModel(
      assetId: map['assetId'] ?? '',
      assetName: map['assetName'] ?? '',
      assetTag: map['assetTag'] ?? '',
      recordCount: map['recordCount']?.toInt() ?? 0,
      lastMaintenance: map['lastMaintenance'] ?? '',
      totalCost: map['totalCost']?.toDouble() ?? 0.0,
      averageCost: map['averageCost']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetMaintenanceRecordStatisticsModel.fromJson(String source) =>
      AssetMaintenanceRecordStatisticsModel.fromMap(json.decode(source));
}

class MaintenanceRecordCostStatisticsModel extends Equatable {
  final double? totalCost;
  final double? averageCost;
  final double? minCost;
  final double? maxCost;
  final int recordsWithCost;
  final int recordsWithoutCost;

  const MaintenanceRecordCostStatisticsModel({
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

  Map<String, dynamic> toMap() {
    return {
      'totalCost': totalCost,
      'averageCost': averageCost,
      'minCost': minCost,
      'maxCost': maxCost,
      'recordsWithCost': recordsWithCost,
      'recordsWithoutCost': recordsWithoutCost,
    };
  }

  factory MaintenanceRecordCostStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceRecordCostStatisticsModel(
      totalCost: map['totalCost']?.toDouble(),
      averageCost: map['averageCost']?.toDouble(),
      minCost: map['minCost']?.toDouble(),
      maxCost: map['maxCost']?.toDouble(),
      recordsWithCost: map['recordsWithCost']?.toInt() ?? 0,
      recordsWithoutCost: map['recordsWithoutCost']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordCostStatisticsModel.fromJson(String source) =>
      MaintenanceRecordCostStatisticsModel.fromMap(json.decode(source));
}

class MaintenanceRecordCompletionTrendModel extends Equatable {
  final DateTime date;
  final int count;

  const MaintenanceRecordCompletionTrendModel({
    required this.date,
    required this.count,
  });

  @override
  List<Object> get props => [date, count];

  Map<String, dynamic> toMap() {
    return {'date': date.millisecondsSinceEpoch, 'count': count};
  }

  factory MaintenanceRecordCompletionTrendModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceRecordCompletionTrendModel(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordCompletionTrendModel.fromJson(String source) =>
      MaintenanceRecordCompletionTrendModel.fromMap(json.decode(source));
}

class MaintenanceRecordMonthlyTrendModel extends Equatable {
  final String month;
  final int recordCount;
  final double totalCost;

  const MaintenanceRecordMonthlyTrendModel({
    required this.month,
    required this.recordCount,
    required this.totalCost,
  });

  @override
  List<Object> get props => [month, recordCount, totalCost];

  Map<String, dynamic> toMap() {
    return {'month': month, 'recordCount': recordCount, 'totalCost': totalCost};
  }

  factory MaintenanceRecordMonthlyTrendModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceRecordMonthlyTrendModel(
      month: map['month'] ?? '',
      recordCount: map['recordCount']?.toInt() ?? 0,
      totalCost: map['totalCost']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordMonthlyTrendModel.fromJson(String source) =>
      MaintenanceRecordMonthlyTrendModel.fromMap(json.decode(source));
}

class MaintenanceRecordSummaryStatisticsModel extends Equatable {
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

  const MaintenanceRecordSummaryStatisticsModel({
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

  Map<String, dynamic> toMap() {
    return {
      'totalRecords': totalRecords,
      'recordsWithCostInfo': recordsWithCostInfo,
      'costInfoPercentage': costInfoPercentage,
      'totalUniqueVendors': totalUniqueVendors,
      'totalUniquePerformers': totalUniquePerformers,
      'averageRecordsPerDay': averageRecordsPerDay,
      'latestRecordDate': latestRecordDate.toIso8601String(),
      'earliestRecordDate': earliestRecordDate.toIso8601String(),
      'mostExpensiveMaintenanceCost': mostExpensiveMaintenanceCost,
      'leastExpensiveMaintenanceCost': leastExpensiveMaintenanceCost,
      'assetsWithMaintenance': assetsWithMaintenance,
      'averageMaintenancePerAsset': averageMaintenancePerAsset,
    };
  }

  factory MaintenanceRecordSummaryStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceRecordSummaryStatisticsModel(
      totalRecords: map['totalRecords']?.toInt() ?? 0,
      recordsWithCostInfo: map['recordsWithCostInfo']?.toInt() ?? 0,
      costInfoPercentage: map['costInfoPercentage']?.toDouble() ?? 0.0,
      totalUniqueVendors: map['totalUniqueVendors']?.toInt() ?? 0,
      totalUniquePerformers: map['totalUniquePerformers']?.toInt() ?? 0,
      averageRecordsPerDay: map['averageRecordsPerDay']?.toDouble() ?? 0.0,
      latestRecordDate: DateTime.parse(map['latestRecordDate'] ?? ''),
      earliestRecordDate: DateTime.parse(map['earliestRecordDate'] ?? ''),
      mostExpensiveMaintenanceCost: map['mostExpensiveMaintenanceCost']
          ?.toDouble(),
      leastExpensiveMaintenanceCost: map['leastExpensiveMaintenanceCost']
          ?.toDouble(),
      assetsWithMaintenance: map['assetsWithMaintenance']?.toInt() ?? 0,
      averageMaintenancePerAsset:
          map['averageMaintenancePerAsset']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordSummaryStatisticsModel.fromJson(String source) =>
      MaintenanceRecordSummaryStatisticsModel.fromMap(json.decode(source));
}
