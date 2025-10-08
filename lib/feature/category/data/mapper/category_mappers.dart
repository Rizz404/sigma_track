import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/data/models/category_model.dart';
import 'package:sigma_track/feature/category/domain/entities/category_statistics.dart';
import 'package:sigma_track/feature/category/data/models/category_statistics_model.dart';

extension CategoryModelMapper on CategoryModel {
  Category toEntity() {
    return Category(
      id: id,
      parentId: parentId,
      categoryCode: categoryCode,
      categoryName: categoryName,
      description: description,
      parent: parent?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations:
          translations?.map((model) => model.toEntity()).toList() ?? [],
    );
  }
}

extension CategoryEntityMapper on Category {
  CategoryModel toModel() {
    return CategoryModel(
      id: id,
      parentId: parentId,
      categoryCode: categoryCode,
      categoryName: categoryName,
      description: description,
      parent: parent?.toModel(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations:
          translations?.map((entity) => entity.toModel()).toList() ?? [],
    );
  }
}

extension CategoryTranslationModelMapper on CategoryTranslationModel {
  CategoryTranslation toEntity() {
    return CategoryTranslation(
      langCode: langCode,
      categoryName: categoryName,
      description: description,
    );
  }
}

extension CategoryTranslationEntityMapper on CategoryTranslation {
  CategoryTranslationModel toModel() {
    return CategoryTranslationModel(
      langCode: langCode,
      categoryName: categoryName,
      description: description,
    );
  }
}

extension CategoryStatisticsModelMapper on CategoryStatisticsModel {
  CategoryStatistics toEntity() {
    return CategoryStatistics(
      total: total.toEntity(),
      byHierarchy: byHierarchy.toEntity(),
      creationTrends: creationTrends.map((model) => model.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

extension CategoryStatisticsEntityMapper on CategoryStatistics {
  CategoryStatisticsModel toModel() {
    return CategoryStatisticsModel(
      total: total.toModel(),
      byHierarchy: byHierarchy.toModel(),
      creationTrends: creationTrends.map((entity) => entity.toModel()).toList(),
      summary: summary.toModel(),
    );
  }
}

extension CategoryCountStatisticsModelMapper on CategoryCountStatisticsModel {
  CategoryCountStatistics toEntity() => CategoryCountStatistics(count: count);
}

extension CategoryCountStatisticsEntityMapper on CategoryCountStatistics {
  CategoryCountStatisticsModel toModel() =>
      CategoryCountStatisticsModel(count: count);
}

extension CategoryHierarchyStatisticsModelMapper
    on CategoryHierarchyStatisticsModel {
  CategoryHierarchyStatistics toEntity() => CategoryHierarchyStatistics(
    topLevel: topLevel,
    withChildren: withChildren,
    withParent: withParent,
  );
}

extension CategoryHierarchyStatisticsEntityMapper
    on CategoryHierarchyStatistics {
  CategoryHierarchyStatisticsModel toModel() =>
      CategoryHierarchyStatisticsModel(
        topLevel: topLevel,
        withChildren: withChildren,
        withParent: withParent,
      );
}

extension CategoryCreationTrendModelMapper on CategoryCreationTrendModel {
  CategoryCreationTrend toEntity() =>
      CategoryCreationTrend(date: DateTime.parse(date), count: count);
}

extension CategoryCreationTrendEntityMapper on CategoryCreationTrend {
  CategoryCreationTrendModel toModel() =>
      CategoryCreationTrendModel(date: date.toIso8601String(), count: count);
}

extension CategorySummaryStatisticsModelMapper
    on CategorySummaryStatisticsModel {
  CategorySummaryStatistics toEntity() => CategorySummaryStatistics(
    totalCategories: totalCategories,
    topLevelPercentage: topLevelPercentage,
    subCategoriesPercentage: subCategoriesPercentage,
    categoriesWithChildrenCount: categoriesWithChildrenCount,
    categoriesWithoutChildrenCount: categoriesWithoutChildrenCount,
    maxDepthLevel: maxDepthLevel,
    averageCategoriesPerDay: averageCategoriesPerDay,
    latestCreationDate: DateTime.parse(latestCreationDate),
    earliestCreationDate: DateTime.parse(earliestCreationDate),
  );
}

extension CategorySummaryStatisticsEntityMapper on CategorySummaryStatistics {
  CategorySummaryStatisticsModel toModel() => CategorySummaryStatisticsModel(
    totalCategories: totalCategories,
    topLevelPercentage: topLevelPercentage,
    subCategoriesPercentage: subCategoriesPercentage,
    categoriesWithChildrenCount: categoriesWithChildrenCount,
    categoriesWithoutChildrenCount: categoriesWithoutChildrenCount,
    maxDepthLevel: maxDepthLevel,
    averageCategoriesPerDay: averageCategoriesPerDay,
    latestCreationDate: latestCreationDate.toIso8601String(),
    earliestCreationDate: earliestCreationDate.toIso8601String(),
  );
}
