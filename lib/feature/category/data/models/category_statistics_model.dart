import 'dart:convert';

import 'package:equatable/equatable.dart';

class CategoryStatisticsModel extends Equatable {
  final CategoryCountStatisticsModel total;
  final CategoryHierarchyStatisticsModel byHierarchy;
  final List<CategoryCreationTrendModel> creationTrends;
  final CategorySummaryStatisticsModel summary;

  const CategoryStatisticsModel({
    required this.total,
    required this.byHierarchy,
    required this.creationTrends,
    required this.summary,
  });

  @override
  List<Object> get props => [total, byHierarchy, creationTrends, summary];

  CategoryStatisticsModel copyWith({
    CategoryCountStatisticsModel? total,
    CategoryHierarchyStatisticsModel? byHierarchy,
    List<CategoryCreationTrendModel>? creationTrends,
    CategorySummaryStatisticsModel? summary,
  }) {
    return CategoryStatisticsModel(
      total: total ?? this.total,
      byHierarchy: byHierarchy ?? this.byHierarchy,
      creationTrends: creationTrends ?? this.creationTrends,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byHierarchy': byHierarchy.toMap(),
      'creationTrends': creationTrends.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory CategoryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return CategoryStatisticsModel(
      total: CategoryCountStatisticsModel.fromMap(map['total']),
      byHierarchy: CategoryHierarchyStatisticsModel.fromMap(map['byHierarchy']),
      creationTrends: List<CategoryCreationTrendModel>.from(
        map['creationTrends']?.map(
          (x) => CategoryCreationTrendModel.fromMap(x),
        ),
      ),
      summary: CategorySummaryStatisticsModel.fromMap(map['summary']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryStatisticsModel.fromJson(String source) =>
      CategoryStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryStatisticsModel(total: $total, byHierarchy: $byHierarchy, creationTrends: $creationTrends, summary: $summary)';
  }
}

class CategoryCountStatisticsModel extends Equatable {
  final int count;

  const CategoryCountStatisticsModel({required this.count});

  @override
  List<Object> get props => [count];

  CategoryCountStatisticsModel copyWith({int? count}) {
    return CategoryCountStatisticsModel(count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory CategoryCountStatisticsModel.fromMap(Map<String, dynamic> map) {
    return CategoryCountStatisticsModel(count: map['count']?.toInt() ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory CategoryCountStatisticsModel.fromJson(String source) =>
      CategoryCountStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryCountStatisticsModel(count: $count)';
}

class CategoryHierarchyStatisticsModel extends Equatable {
  final int topLevel;
  final int withChildren;
  final int withParent;

  const CategoryHierarchyStatisticsModel({
    required this.topLevel,
    required this.withChildren,
    required this.withParent,
  });

  @override
  List<Object> get props => [topLevel, withChildren, withParent];

  CategoryHierarchyStatisticsModel copyWith({
    int? topLevel,
    int? withChildren,
    int? withParent,
  }) {
    return CategoryHierarchyStatisticsModel(
      topLevel: topLevel ?? this.topLevel,
      withChildren: withChildren ?? this.withChildren,
      withParent: withParent ?? this.withParent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'topLevel': topLevel,
      'withChildren': withChildren,
      'withParent': withParent,
    };
  }

  factory CategoryHierarchyStatisticsModel.fromMap(Map<String, dynamic> map) {
    return CategoryHierarchyStatisticsModel(
      topLevel: map['topLevel']?.toInt() ?? 0,
      withChildren: map['withChildren']?.toInt() ?? 0,
      withParent: map['withParent']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryHierarchyStatisticsModel.fromJson(String source) =>
      CategoryHierarchyStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CategoryHierarchyStatisticsModel(topLevel: $topLevel, withChildren: $withChildren, withParent: $withParent)';
}

class CategoryCreationTrendModel extends Equatable {
  final String date;
  final int count;

  const CategoryCreationTrendModel({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];

  CategoryCreationTrendModel copyWith({String? date, int? count}) {
    return CategoryCreationTrendModel(
      date: date ?? this.date,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date, 'count': count};
  }

  factory CategoryCreationTrendModel.fromMap(Map<String, dynamic> map) {
    return CategoryCreationTrendModel(
      date: map['date'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryCreationTrendModel.fromJson(String source) =>
      CategoryCreationTrendModel.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryCreationTrendModel(date: $date, count: $count)';
}

class CategorySummaryStatisticsModel extends Equatable {
  final int totalCategories;
  final double topLevelPercentage;
  final double subCategoriesPercentage;
  final int categoriesWithChildrenCount;
  final int categoriesWithoutChildrenCount;
  final int maxDepthLevel;
  final double averageCategoriesPerDay;
  final String latestCreationDate;
  final String earliestCreationDate;

  const CategorySummaryStatisticsModel({
    required this.totalCategories,
    required this.topLevelPercentage,
    required this.subCategoriesPercentage,
    required this.categoriesWithChildrenCount,
    required this.categoriesWithoutChildrenCount,
    required this.maxDepthLevel,
    required this.averageCategoriesPerDay,
    required this.latestCreationDate,
    required this.earliestCreationDate,
  });

  @override
  List<Object> get props {
    return [
      totalCategories,
      topLevelPercentage,
      subCategoriesPercentage,
      categoriesWithChildrenCount,
      categoriesWithoutChildrenCount,
      maxDepthLevel,
      averageCategoriesPerDay,
      latestCreationDate,
      earliestCreationDate,
    ];
  }

  CategorySummaryStatisticsModel copyWith({
    int? totalCategories,
    double? topLevelPercentage,
    double? subCategoriesPercentage,
    int? categoriesWithChildrenCount,
    int? categoriesWithoutChildrenCount,
    int? maxDepthLevel,
    double? averageCategoriesPerDay,
    String? latestCreationDate,
    String? earliestCreationDate,
  }) {
    return CategorySummaryStatisticsModel(
      totalCategories: totalCategories ?? this.totalCategories,
      topLevelPercentage: topLevelPercentage ?? this.topLevelPercentage,
      subCategoriesPercentage:
          subCategoriesPercentage ?? this.subCategoriesPercentage,
      categoriesWithChildrenCount:
          categoriesWithChildrenCount ?? this.categoriesWithChildrenCount,
      categoriesWithoutChildrenCount:
          categoriesWithoutChildrenCount ?? this.categoriesWithoutChildrenCount,
      maxDepthLevel: maxDepthLevel ?? this.maxDepthLevel,
      averageCategoriesPerDay:
          averageCategoriesPerDay ?? this.averageCategoriesPerDay,
      latestCreationDate: latestCreationDate ?? this.latestCreationDate,
      earliestCreationDate: earliestCreationDate ?? this.earliestCreationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalCategories': totalCategories,
      'topLevelPercentage': topLevelPercentage,
      'subCategoriesPercentage': subCategoriesPercentage,
      'categoriesWithChildrenCount': categoriesWithChildrenCount,
      'categoriesWithoutChildrenCount': categoriesWithoutChildrenCount,
      'maxDepthLevel': maxDepthLevel,
      'averageCategoriesPerDay': averageCategoriesPerDay,
      'latestCreationDate': latestCreationDate,
      'earliestCreationDate': earliestCreationDate,
    };
  }

  factory CategorySummaryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return CategorySummaryStatisticsModel(
      totalCategories: map['totalCategories']?.toInt() ?? 0,
      topLevelPercentage: map['topLevelPercentage']?.toDouble() ?? 0.0,
      subCategoriesPercentage:
          map['subCategoriesPercentage']?.toDouble() ?? 0.0,
      categoriesWithChildrenCount:
          map['categoriesWithChildrenCount']?.toInt() ?? 0,
      categoriesWithoutChildrenCount:
          map['categoriesWithoutChildrenCount']?.toInt() ?? 0,
      maxDepthLevel: map['maxDepthLevel']?.toInt() ?? 0,
      averageCategoriesPerDay:
          map['averageCategoriesPerDay']?.toDouble() ?? 0.0,
      latestCreationDate: map['latestCreationDate'] ?? '',
      earliestCreationDate: map['earliestCreationDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategorySummaryStatisticsModel.fromJson(String source) =>
      CategorySummaryStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategorySummaryStatisticsModel(totalCategories: $totalCategories, topLevelPercentage: $topLevelPercentage, subCategoriesPercentage: $subCategoriesPercentage, categoriesWithChildrenCount: $categoriesWithChildrenCount, categoriesWithoutChildrenCount: $categoriesWithoutChildrenCount, maxDepthLevel: $maxDepthLevel, averageCategoriesPerDay: $averageCategoriesPerDay, latestCreationDate: $latestCreationDate, earliestCreationDate: $earliestCreationDate)';
  }
}
