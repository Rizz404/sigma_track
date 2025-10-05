import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';

class CategoriesFilter extends Equatable {
  final String? search;
  final String? parentId;
  final bool? hasParent;
  final CategorySortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  CategoriesFilter({
    this.search,
    this.parentId,
    this.hasParent,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  CategoriesFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? parentId,
    ValueGetter<bool?>? hasParent,
    ValueGetter<CategorySortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return CategoriesFilter(
      search: search != null ? search() : this.search,
      parentId: parentId != null ? parentId() : this.parentId,
      hasParent: hasParent != null ? hasParent() : this.hasParent,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  @override
  List<Object?> get props {
    return [search, parentId, hasParent, sortBy, sortOrder, cursor, limit];
  }

  @override
  String toString() {
    return 'CategoriesFilter(search: $search, parentId: $parentId, hasParent: $hasParent, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';
  }
}

class CategoriesState extends Equatable {
  final List<Category> categories;
  final Category? mutatedCategory;
  final CategoriesFilter categoriesFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const CategoriesState({
    this.categories = const [],
    this.mutatedCategory,
    required this.categoriesFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory CategoriesState.initial() =>
      CategoriesState(categoriesFilter: CategoriesFilter(), isLoading: true);

  factory CategoriesState.loading({
    required CategoriesFilter categoriesFilter,
    List<Category>? currentCategories,
  }) => CategoriesState(
    categories: currentCategories ?? const [],
    categoriesFilter: categoriesFilter,
    isLoading: true,
  );

  factory CategoriesState.success({
    required List<Category> categories,
    required CategoriesFilter categoriesFilter,
    Cursor? cursor,
    String? message,
    Category? mutatedCategory,
  }) => CategoriesState(
    categories: categories,
    categoriesFilter: categoriesFilter,
    cursor: cursor,
    message: message,
    mutatedCategory: mutatedCategory,
  );

  factory CategoriesState.error({
    required Failure failure,
    required CategoriesFilter categoriesFilter,
    List<Category>? currentCategories,
  }) => CategoriesState(
    categories: currentCategories ?? const [],
    categoriesFilter: categoriesFilter,
    failure: failure,
  );

  factory CategoriesState.loadingMore({
    required List<Category> currentCategories,
    required CategoriesFilter categoriesFilter,
    Cursor? cursor,
  }) => CategoriesState(
    categories: currentCategories,
    categoriesFilter: categoriesFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  CategoriesState copyWith({
    List<Category>? categories,
    ValueGetter<Category?>? mutatedCategory,
    CategoriesFilter? categoriesFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      mutatedCategory: mutatedCategory != null
          ? mutatedCategory()
          : this.mutatedCategory,
      categoriesFilter: categoriesFilter ?? this.categoriesFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMutating: isMutating ?? this.isMutating,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  @override
  List<Object?> get props {
    return [
      categories,
      mutatedCategory,
      categoriesFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
