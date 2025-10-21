import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class AssetStatisticsModel extends Equatable {
  final AssetCountStatisticsModel total;
  final AssetStatusStatisticsModel byStatus;
  final AssetConditionStatisticsModel byCondition;
  final List<CategoryStatisticsModel> byCategory;
  final List<LocationStatisticsModel> byLocation;
  final AssetAssignmentStatisticsModel byAssignment;
  final AssetValueStatisticsModel valueStatistics;
  final AssetWarrantyStatisticsModel warrantyStatistics;
  final List<AssetCreationTrendModel> creationTrends;
  final AssetSummaryStatisticsModel summary;

  const AssetStatisticsModel({
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

  AssetStatisticsModel copyWith({
    AssetCountStatisticsModel? total,
    AssetStatusStatisticsModel? byStatus,
    AssetConditionStatisticsModel? byCondition,
    List<CategoryStatisticsModel>? byCategory,
    List<LocationStatisticsModel>? byLocation,
    AssetAssignmentStatisticsModel? byAssignment,
    AssetValueStatisticsModel? valueStatistics,
    AssetWarrantyStatisticsModel? warrantyStatistics,
    List<AssetCreationTrendModel>? creationTrends,
    AssetSummaryStatisticsModel? summary,
  }) {
    return AssetStatisticsModel(
      total: total ?? this.total,
      byStatus: byStatus ?? this.byStatus,
      byCondition: byCondition ?? this.byCondition,
      byCategory: byCategory ?? this.byCategory,
      byLocation: byLocation ?? this.byLocation,
      byAssignment: byAssignment ?? this.byAssignment,
      valueStatistics: valueStatistics ?? this.valueStatistics,
      warrantyStatistics: warrantyStatistics ?? this.warrantyStatistics,
      creationTrends: creationTrends ?? this.creationTrends,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byStatus': byStatus.toMap(),
      'byCondition': byCondition.toMap(),
      'byCategory': byCategory.map((x) => x.toMap()).toList(),
      'byLocation': byLocation.map((x) => x.toMap()).toList(),
      'byAssignment': byAssignment.toMap(),
      'valueStatistics': valueStatistics.toMap(),
      'warrantyStatistics': warrantyStatistics.toMap(),
      'creationTrends': creationTrends.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory AssetStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetStatisticsModel(
      total: AssetCountStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('total'),
      ),
      byStatus: AssetStatusStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byStatus'),
      ),
      byCondition: AssetConditionStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byCondition'),
      ),
      byCategory: List<CategoryStatisticsModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('byCategory')
                ?.map((x) => CategoryStatisticsModel.fromMap(x)) ??
            [],
      ),
      byLocation: List<LocationStatisticsModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('byLocation')
                ?.map((x) => LocationStatisticsModel.fromMap(x)) ??
            [],
      ),
      byAssignment: AssetAssignmentStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byAssignment'),
      ),
      valueStatistics: AssetValueStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('valueStatistics'),
      ),
      warrantyStatistics: AssetWarrantyStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('warrantyStatistics'),
      ),
      creationTrends: List<AssetCreationTrendModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('creationTrends')
                ?.map((x) => AssetCreationTrendModel.fromMap(x)) ??
            [],
      ),
      summary: AssetSummaryStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('summary'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetStatisticsModel.fromJson(String source) =>
      AssetStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AssetStatisticsModel(total: $total, byStatus: $byStatus, byCondition: $byCondition, byCategory: $byCategory, byLocation: $byLocation, byAssignment: $byAssignment, valueStatistics: $valueStatistics, warrantyStatistics: $warrantyStatistics, creationTrends: $creationTrends, summary: $summary)';
  }
}

class AssetCountStatisticsModel extends Equatable {
  final int count;

  const AssetCountStatisticsModel({required this.count});

  @override
  List<Object> get props => [count];

  AssetCountStatisticsModel copyWith({int? count}) {
    return AssetCountStatisticsModel(count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory AssetCountStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetCountStatisticsModel(count: map['count']?.toInt() ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory AssetCountStatisticsModel.fromJson(String source) =>
      AssetCountStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() => 'AssetCountStatisticsModel(count: $count)';
}

class AssetStatusStatisticsModel extends Equatable {
  final int active;
  final int maintenance;
  final int disposed;
  final int lost;

  const AssetStatusStatisticsModel({
    required this.active,
    required this.maintenance,
    required this.disposed,
    required this.lost,
  });

  @override
  List<Object> get props => [active, maintenance, disposed, lost];

  AssetStatusStatisticsModel copyWith({
    int? active,
    int? maintenance,
    int? disposed,
    int? lost,
  }) {
    return AssetStatusStatisticsModel(
      active: active ?? this.active,
      maintenance: maintenance ?? this.maintenance,
      disposed: disposed ?? this.disposed,
      lost: lost ?? this.lost,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'active': active,
      'maintenance': maintenance,
      'disposed': disposed,
      'lost': lost,
    };
  }

  factory AssetStatusStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetStatusStatisticsModel(
      active: map['active']?.toInt() ?? 0,
      maintenance: map['maintenance']?.toInt() ?? 0,
      disposed: map['disposed']?.toInt() ?? 0,
      lost: map['lost']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetStatusStatisticsModel.fromJson(String source) =>
      AssetStatusStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AssetStatusStatisticsModel(active: $active, maintenance: $maintenance, disposed: $disposed, lost: $lost)';
}

class AssetConditionStatisticsModel extends Equatable {
  final int good;
  final int fair;
  final int poor;
  final int damaged;

  const AssetConditionStatisticsModel({
    required this.good,
    required this.fair,
    required this.poor,
    required this.damaged,
  });

  @override
  List<Object> get props => [good, fair, poor, damaged];

  AssetConditionStatisticsModel copyWith({
    int? good,
    int? fair,
    int? poor,
    int? damaged,
  }) {
    return AssetConditionStatisticsModel(
      good: good ?? this.good,
      fair: fair ?? this.fair,
      poor: poor ?? this.poor,
      damaged: damaged ?? this.damaged,
    );
  }

  Map<String, dynamic> toMap() {
    return {'good': good, 'fair': fair, 'poor': poor, 'damaged': damaged};
  }

  factory AssetConditionStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetConditionStatisticsModel(
      good: map['good']?.toInt() ?? 0,
      fair: map['fair']?.toInt() ?? 0,
      poor: map['poor']?.toInt() ?? 0,
      damaged: map['damaged']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetConditionStatisticsModel.fromJson(String source) =>
      AssetConditionStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AssetConditionStatisticsModel(good: $good, fair: $fair, poor: $poor, damaged: $damaged)';
}

class AssetAssignmentStatisticsModel extends Equatable {
  final int assigned;
  final int unassigned;

  const AssetAssignmentStatisticsModel({
    required this.assigned,
    required this.unassigned,
  });

  @override
  List<Object> get props => [assigned, unassigned];

  AssetAssignmentStatisticsModel copyWith({int? assigned, int? unassigned}) {
    return AssetAssignmentStatisticsModel(
      assigned: assigned ?? this.assigned,
      unassigned: unassigned ?? this.unassigned,
    );
  }

  Map<String, dynamic> toMap() {
    return {'assigned': assigned, 'unassigned': unassigned};
  }

  factory AssetAssignmentStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetAssignmentStatisticsModel(
      assigned: map['assigned']?.toInt() ?? 0,
      unassigned: map['unassigned']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetAssignmentStatisticsModel.fromJson(String source) =>
      AssetAssignmentStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AssetAssignmentStatisticsModel(assigned: $assigned, unassigned: $unassigned)';
}

class AssetValueStatisticsModel extends Equatable {
  final double? totalValue;
  final double? averageValue;
  final double? minValue;
  final double? maxValue;
  final int assetsWithValue;
  final int assetsWithoutValue;

  const AssetValueStatisticsModel({
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

  AssetValueStatisticsModel copyWith({
    double? totalValue,
    double? averageValue,
    double? minValue,
    double? maxValue,
    int? assetsWithValue,
    int? assetsWithoutValue,
  }) {
    return AssetValueStatisticsModel(
      totalValue: totalValue ?? this.totalValue,
      averageValue: averageValue ?? this.averageValue,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      assetsWithValue: assetsWithValue ?? this.assetsWithValue,
      assetsWithoutValue: assetsWithoutValue ?? this.assetsWithoutValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalValue': totalValue,
      'averageValue': averageValue,
      'minValue': minValue,
      'maxValue': maxValue,
      'assetsWithValue': assetsWithValue,
      'assetsWithoutValue': assetsWithoutValue,
    };
  }

  factory AssetValueStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetValueStatisticsModel(
      totalValue: map['totalValue']?.toDouble(),
      averageValue: map['averageValue']?.toDouble(),
      minValue: map['minValue']?.toDouble(),
      maxValue: map['maxValue']?.toDouble(),
      assetsWithValue: map['assetsWithValue']?.toInt() ?? 0,
      assetsWithoutValue: map['assetsWithoutValue']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetValueStatisticsModel.fromJson(String source) =>
      AssetValueStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AssetValueStatisticsModel(totalValue: $totalValue, averageValue: $averageValue, minValue: $minValue, maxValue: $maxValue, assetsWithValue: $assetsWithValue, assetsWithoutValue: $assetsWithoutValue)';
}

class AssetWarrantyStatisticsModel extends Equatable {
  final int activeWarranties;
  final int expiredWarranties;
  final int noWarrantyInfo;

  const AssetWarrantyStatisticsModel({
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

  AssetWarrantyStatisticsModel copyWith({
    int? activeWarranties,
    int? expiredWarranties,
    int? noWarrantyInfo,
  }) {
    return AssetWarrantyStatisticsModel(
      activeWarranties: activeWarranties ?? this.activeWarranties,
      expiredWarranties: expiredWarranties ?? this.expiredWarranties,
      noWarrantyInfo: noWarrantyInfo ?? this.noWarrantyInfo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activeWarranties': activeWarranties,
      'expiredWarranties': expiredWarranties,
      'noWarrantyInfo': noWarrantyInfo,
    };
  }

  factory AssetWarrantyStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetWarrantyStatisticsModel(
      activeWarranties: map['activeWarranties']?.toInt() ?? 0,
      expiredWarranties: map['expiredWarranties']?.toInt() ?? 0,
      noWarrantyInfo: map['noWarrantyInfo']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetWarrantyStatisticsModel.fromJson(String source) =>
      AssetWarrantyStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AssetWarrantyStatisticsModel(activeWarranties: $activeWarranties, expiredWarranties: $expiredWarranties, noWarrantyInfo: $noWarrantyInfo)';
}

class AssetCreationTrendModel extends Equatable {
  final String date;
  final int count;

  const AssetCreationTrendModel({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];

  AssetCreationTrendModel copyWith({String? date, int? count}) {
    return AssetCreationTrendModel(
      date: date ?? this.date,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date, 'count': count};
  }

  factory AssetCreationTrendModel.fromMap(Map<String, dynamic> map) {
    return AssetCreationTrendModel(
      date: map['date'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetCreationTrendModel.fromJson(String source) =>
      AssetCreationTrendModel.fromMap(json.decode(source));

  @override
  String toString() => 'AssetCreationTrendModel(date: $date, count: $count)';
}

class AssetSummaryStatisticsModel extends Equatable {
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
  final String latestCreationDate;
  final String earliestCreationDate;
  final double? mostExpensiveAssetValue;
  final double? leastExpensiveAssetValue;

  const AssetSummaryStatisticsModel({
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

  AssetSummaryStatisticsModel copyWith({
    int? totalAssets,
    double? activeAssetsPercentage,
    double? maintenanceAssetsPercentage,
    double? disposedAssetsPercentage,
    double? lostAssetsPercentage,
    double? goodConditionPercentage,
    double? fairConditionPercentage,
    double? poorConditionPercentage,
    double? damagedConditionPercentage,
    double? assignedAssetsPercentage,
    double? unassignedAssetsPercentage,
    int? assetsWithPurchasePrice,
    double? purchasePricePercentage,
    int? assetsWithDataMatrix,
    double? dataMatrixPercentage,
    int? assetsWithWarranty,
    double? warrantyPercentage,
    int? totalCategories,
    int? totalLocations,
    double? averageAssetsPerDay,
    String? latestCreationDate,
    String? earliestCreationDate,
    double? mostExpensiveAssetValue,
    double? leastExpensiveAssetValue,
  }) {
    return AssetSummaryStatisticsModel(
      totalAssets: totalAssets ?? this.totalAssets,
      activeAssetsPercentage:
          activeAssetsPercentage ?? this.activeAssetsPercentage,
      maintenanceAssetsPercentage:
          maintenanceAssetsPercentage ?? this.maintenanceAssetsPercentage,
      disposedAssetsPercentage:
          disposedAssetsPercentage ?? this.disposedAssetsPercentage,
      lostAssetsPercentage: lostAssetsPercentage ?? this.lostAssetsPercentage,
      goodConditionPercentage:
          goodConditionPercentage ?? this.goodConditionPercentage,
      fairConditionPercentage:
          fairConditionPercentage ?? this.fairConditionPercentage,
      poorConditionPercentage:
          poorConditionPercentage ?? this.poorConditionPercentage,
      damagedConditionPercentage:
          damagedConditionPercentage ?? this.damagedConditionPercentage,
      assignedAssetsPercentage:
          assignedAssetsPercentage ?? this.assignedAssetsPercentage,
      unassignedAssetsPercentage:
          unassignedAssetsPercentage ?? this.unassignedAssetsPercentage,
      assetsWithPurchasePrice:
          assetsWithPurchasePrice ?? this.assetsWithPurchasePrice,
      purchasePricePercentage:
          purchasePricePercentage ?? this.purchasePricePercentage,
      assetsWithDataMatrix: assetsWithDataMatrix ?? this.assetsWithDataMatrix,
      dataMatrixPercentage: dataMatrixPercentage ?? this.dataMatrixPercentage,
      assetsWithWarranty: assetsWithWarranty ?? this.assetsWithWarranty,
      warrantyPercentage: warrantyPercentage ?? this.warrantyPercentage,
      totalCategories: totalCategories ?? this.totalCategories,
      totalLocations: totalLocations ?? this.totalLocations,
      averageAssetsPerDay: averageAssetsPerDay ?? this.averageAssetsPerDay,
      latestCreationDate: latestCreationDate ?? this.latestCreationDate,
      earliestCreationDate: earliestCreationDate ?? this.earliestCreationDate,
      mostExpensiveAssetValue:
          mostExpensiveAssetValue ?? this.mostExpensiveAssetValue,
      leastExpensiveAssetValue:
          leastExpensiveAssetValue ?? this.leastExpensiveAssetValue,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalAssets': totalAssets,
      'activeAssetsPercentage': activeAssetsPercentage,
      'maintenanceAssetsPercentage': maintenanceAssetsPercentage,
      'disposedAssetsPercentage': disposedAssetsPercentage,
      'lostAssetsPercentage': lostAssetsPercentage,
      'goodConditionPercentage': goodConditionPercentage,
      'fairConditionPercentage': fairConditionPercentage,
      'poorConditionPercentage': poorConditionPercentage,
      'damagedConditionPercentage': damagedConditionPercentage,
      'assignedAssetsPercentage': assignedAssetsPercentage,
      'unassignedAssetsPercentage': unassignedAssetsPercentage,
      'assetsWithPurchasePrice': assetsWithPurchasePrice,
      'purchasePricePercentage': purchasePricePercentage,
      'assetsWithDataMatrix': assetsWithDataMatrix,
      'dataMatrixPercentage': dataMatrixPercentage,
      'assetsWithWarranty': assetsWithWarranty,
      'warrantyPercentage': warrantyPercentage,
      'totalCategories': totalCategories,
      'totalLocations': totalLocations,
      'averageAssetsPerDay': averageAssetsPerDay,
      'latestCreationDate': latestCreationDate,
      'earliestCreationDate': earliestCreationDate,
      'mostExpensiveAssetValue': mostExpensiveAssetValue,
      'leastExpensiveAssetValue': leastExpensiveAssetValue,
    };
  }

  factory AssetSummaryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetSummaryStatisticsModel(
      totalAssets: map['totalAssets']?.toInt() ?? 0,
      activeAssetsPercentage: map['activeAssetsPercentage']?.toDouble() ?? 0.0,
      maintenanceAssetsPercentage:
          map['maintenanceAssetsPercentage']?.toDouble() ?? 0.0,
      disposedAssetsPercentage:
          map['disposedAssetsPercentage']?.toDouble() ?? 0.0,
      lostAssetsPercentage: map['lostAssetsPercentage']?.toDouble() ?? 0.0,
      goodConditionPercentage:
          map['goodConditionPercentage']?.toDouble() ?? 0.0,
      fairConditionPercentage:
          map['fairConditionPercentage']?.toDouble() ?? 0.0,
      poorConditionPercentage:
          map['poorConditionPercentage']?.toDouble() ?? 0.0,
      damagedConditionPercentage:
          map['damagedConditionPercentage']?.toDouble() ?? 0.0,
      assignedAssetsPercentage:
          map['assignedAssetsPercentage']?.toDouble() ?? 0.0,
      unassignedAssetsPercentage:
          map['unassignedAssetsPercentage']?.toDouble() ?? 0.0,
      assetsWithPurchasePrice: map['assetsWithPurchasePrice']?.toInt() ?? 0,
      purchasePricePercentage:
          map['purchasePricePercentage']?.toDouble() ?? 0.0,
      assetsWithDataMatrix: map['assetsWithDataMatrix']?.toInt() ?? 0,
      dataMatrixPercentage: map['dataMatrixPercentage']?.toDouble() ?? 0.0,
      assetsWithWarranty: map['assetsWithWarranty']?.toInt() ?? 0,
      warrantyPercentage: map['warrantyPercentage']?.toDouble() ?? 0.0,
      totalCategories: map['totalCategories']?.toInt() ?? 0,
      totalLocations: map['totalLocations']?.toInt() ?? 0,
      averageAssetsPerDay: map['averageAssetsPerDay']?.toDouble() ?? 0.0,
      latestCreationDate: map['latestCreationDate'] ?? '',
      earliestCreationDate: map['earliestCreationDate'] ?? '',
      mostExpensiveAssetValue: map['mostExpensiveAssetValue']?.toDouble(),
      leastExpensiveAssetValue: map['leastExpensiveAssetValue']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetSummaryStatisticsModel.fromJson(String source) =>
      AssetSummaryStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AssetSummaryStatisticsModel(totalAssets: $totalAssets, activeAssetsPercentage: $activeAssetsPercentage, maintenanceAssetsPercentage: $maintenanceAssetsPercentage, disposedAssetsPercentage: $disposedAssetsPercentage, lostAssetsPercentage: $lostAssetsPercentage, goodConditionPercentage: $goodConditionPercentage, fairConditionPercentage: $fairConditionPercentage, poorConditionPercentage: $poorConditionPercentage, damagedConditionPercentage: $damagedConditionPercentage, assignedAssetsPercentage: $assignedAssetsPercentage, unassignedAssetsPercentage: $unassignedAssetsPercentage, assetsWithPurchasePrice: $assetsWithPurchasePrice, purchasePricePercentage: $purchasePricePercentage, assetsWithDataMatrix: $assetsWithDataMatrix, dataMatrixPercentage: $dataMatrixPercentage, assetsWithWarranty: $assetsWithWarranty, warrantyPercentage: $warrantyPercentage, totalCategories: $totalCategories, totalLocations: $totalLocations, averageAssetsPerDay: $averageAssetsPerDay, latestCreationDate: $latestCreationDate, earliestCreationDate: $earliestCreationDate, mostExpensiveAssetValue: $mostExpensiveAssetValue, leastExpensiveAssetValue: $leastExpensiveAssetValue)';
  }
}

class CategoryStatisticsModel extends Equatable {
  final String categoryId;
  final String categoryName;
  final String categoryCode;
  final int assetCount;
  final double percentage;

  const CategoryStatisticsModel({
    required this.categoryId,
    required this.categoryName,
    required this.categoryCode,
    required this.assetCount,
    required this.percentage,
  });

  @override
  List<Object> get props => [
    categoryId,
    categoryName,
    categoryCode,
    assetCount,
    percentage,
  ];

  CategoryStatisticsModel copyWith({
    String? categoryId,
    String? categoryName,
    String? categoryCode,
    int? assetCount,
    double? percentage,
  }) {
    return CategoryStatisticsModel(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryCode: categoryCode ?? this.categoryCode,
      assetCount: assetCount ?? this.assetCount,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryCode': categoryCode,
      'assetCount': assetCount,
      'percentage': percentage,
    };
  }

  factory CategoryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return CategoryStatisticsModel(
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      categoryCode: map['categoryCode'] ?? '',
      assetCount: map['assetCount']?.toInt() ?? 0,
      percentage: map['percentage']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryStatisticsModel.fromJson(String source) =>
      CategoryStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryStatisticsModel(categoryId: $categoryId, categoryName: $categoryName, categoryCode: $categoryCode, assetCount: $assetCount, percentage: $percentage)';
  }
}

class LocationStatisticsModel extends Equatable {
  final String locationId;
  final String locationName;
  final String locationCode;
  final int assetCount;
  final double percentage;

  const LocationStatisticsModel({
    required this.locationId,
    required this.locationName,
    required this.locationCode,
    required this.assetCount,
    required this.percentage,
  });

  @override
  List<Object> get props => [
    locationId,
    locationName,
    locationCode,
    assetCount,
    percentage,
  ];

  LocationStatisticsModel copyWith({
    String? locationId,
    String? locationName,
    String? locationCode,
    int? assetCount,
    double? percentage,
  }) {
    return LocationStatisticsModel(
      locationId: locationId ?? this.locationId,
      locationName: locationName ?? this.locationName,
      locationCode: locationCode ?? this.locationCode,
      assetCount: assetCount ?? this.assetCount,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locationId': locationId,
      'locationName': locationName,
      'locationCode': locationCode,
      'assetCount': assetCount,
      'percentage': percentage,
    };
  }

  factory LocationStatisticsModel.fromMap(Map<String, dynamic> map) {
    return LocationStatisticsModel(
      locationId: map['locationId'] ?? '',
      locationName: map['locationName'] ?? '',
      locationCode: map['locationCode'] ?? '',
      assetCount: map['assetCount']?.toInt() ?? 0,
      percentage: map['percentage']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationStatisticsModel.fromJson(String source) =>
      LocationStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LocationStatisticsModel(locationId: $locationId, locationName: $locationName, locationCode: $locationCode, assetCount: $assetCount, percentage: $percentage)';
  }
}
