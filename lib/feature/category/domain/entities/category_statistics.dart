import 'package:equatable/equatable.dart';

class CategoryStatistics extends Equatable {
  final CategoryCountStatistics total;
  final CategoryHierarchyStatistics byHierarchy;
  final List<CategoryCreationTrend> creationTrends;
  final CategorySummaryStatistics summary;

  const CategoryStatistics({
    required this.total,
    required this.byHierarchy,
    required this.creationTrends,
    required this.summary,
  });

  factory CategoryStatistics.dummy() => CategoryStatistics(
    total: const CategoryCountStatistics(count: 0),
    byHierarchy: const CategoryHierarchyStatistics(
      topLevel: 0,
      withChildren: 0,
      withParent: 0,
    ),
    creationTrends: const [],
    summary: CategorySummaryStatistics(
      totalCategories: 0,
      topLevelPercentage: 0.0,
      subCategoriesPercentage: 0.0,
      categoriesWithChildrenCount: 0,
      categoriesWithoutChildrenCount: 0,
      maxDepthLevel: 0,
      averageCategoriesPerDay: 0.0,
      latestCreationDate: DateTime(0),
      earliestCreationDate: DateTime(0),
    ),
  );

  @override
  List<Object> get props {
    return [total, byHierarchy, creationTrends, summary];
  }
}

class CategoryCountStatistics extends Equatable {
  final int count;

  const CategoryCountStatistics({required this.count});

  @override
  List<Object> get props => [count];
}

class CategoryHierarchyStatistics extends Equatable {
  final int topLevel;
  final int withChildren;
  final int withParent;

  const CategoryHierarchyStatistics({
    required this.topLevel,
    required this.withChildren,
    required this.withParent,
  });

  @override
  List<Object> get props => [topLevel, withChildren, withParent];
}

class CategoryCreationTrend extends Equatable {
  final DateTime date;
  final int count;

  const CategoryCreationTrend({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];
}

class CategorySummaryStatistics extends Equatable {
  final int totalCategories;
  final double topLevelPercentage;
  final double subCategoriesPercentage;
  final int categoriesWithChildrenCount;
  final int categoriesWithoutChildrenCount;
  final int maxDepthLevel;
  final double averageCategoriesPerDay;
  final DateTime latestCreationDate;
  final DateTime earliestCreationDate;

  const CategorySummaryStatistics({
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
  List<Object> get props => [
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
