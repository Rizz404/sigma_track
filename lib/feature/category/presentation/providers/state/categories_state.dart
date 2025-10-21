import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_cursor_usecase.dart';

// * Category mutation state
class CategoryMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;

  const CategoryMutationState({
    required this.type,
    this.isLoading = false,
    this.successMessage,
    this.failure,
  });

  bool get isSuccess => successMessage != null && failure == null;
  bool get isError => failure != null;

  @override
  List<Object?> get props => [type, isLoading, successMessage, failure];
}

class CategoriesState extends Equatable {
  final List<Category> categories;
  final Category? mutatedCategory;
  final GetCategoriesCursorUsecaseParams categoriesFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final CategoryMutationState? mutation;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const CategoriesState({
    this.categories = const [],
    this.mutatedCategory,
    required this.categoriesFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.mutation,
    this.message,
    this.failure,
    this.cursor,
  });

  factory CategoriesState.initial() => CategoriesState(
    categoriesFilter: GetCategoriesCursorUsecaseParams(),
    isLoading: true,
  );

  factory CategoriesState.loading({
    required GetCategoriesCursorUsecaseParams categoriesFilter,
    List<Category>? currentCategories,
  }) => CategoriesState(
    categories: currentCategories ?? const [],
    categoriesFilter: categoriesFilter,
    isLoading: true,
  );

  factory CategoriesState.success({
    required List<Category> categories,
    required GetCategoriesCursorUsecaseParams categoriesFilter,
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
    required GetCategoriesCursorUsecaseParams categoriesFilter,
    List<Category>? currentCategories,
  }) => CategoriesState(
    categories: currentCategories ?? const [],
    categoriesFilter: categoriesFilter,
    failure: failure,
  );

  factory CategoriesState.loadingMore({
    required List<Category> currentCategories,
    required GetCategoriesCursorUsecaseParams categoriesFilter,
    Cursor? cursor,
  }) => CategoriesState(
    categories: currentCategories,
    categoriesFilter: categoriesFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Mutation state for descriptive mutation operations
  factory CategoriesState.creating({
    required List<Category> currentCategories,
    required GetCategoriesCursorUsecaseParams categoriesFilter,
    Cursor? cursor,
  }) => CategoriesState(
    categories: currentCategories,
    categoriesFilter: categoriesFilter,
    cursor: cursor,
    mutation: const CategoryMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory CategoriesState.updating({
    required List<Category> currentCategories,
    required GetCategoriesCursorUsecaseParams categoriesFilter,
    Cursor? cursor,
  }) => CategoriesState(
    categories: currentCategories,
    categoriesFilter: categoriesFilter,
    cursor: cursor,
    mutation: const CategoryMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory CategoriesState.deleting({
    required List<Category> currentCategories,
    required GetCategoriesCursorUsecaseParams categoriesFilter,
    Cursor? cursor,
  }) => CategoriesState(
    categories: currentCategories,
    categoriesFilter: categoriesFilter,
    cursor: cursor,
    mutation: const CategoryMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory CategoriesState.mutationSuccess({
    required List<Category> categories,
    required GetCategoriesCursorUsecaseParams categoriesFilter,
    required MutationType mutationType,
    required String message,
    Cursor? cursor,
  }) => CategoriesState(
    categories: categories,
    categoriesFilter: categoriesFilter,
    cursor: cursor,
    mutation: CategoryMutationState(
      type: mutationType,
      successMessage: message,
    ),
  );

  factory CategoriesState.mutationError({
    required List<Category> currentCategories,
    required GetCategoriesCursorUsecaseParams categoriesFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => CategoriesState(
    categories: currentCategories,
    categoriesFilter: categoriesFilter,
    cursor: cursor,
    mutation: CategoryMutationState(type: mutationType, failure: failure),
  );

  CategoriesState copyWith({
    List<Category>? categories,
    ValueGetter<Category?>? mutatedCategory,
    GetCategoriesCursorUsecaseParams? categoriesFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<CategoryMutationState?>? mutation,
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
      mutation: mutation != null ? mutation() : this.mutation,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Computed properties for UI convenience (derived from mutation)
  bool get isMutating => mutation?.isLoading ?? false;
  bool get isCreating =>
      mutation?.type == MutationType.create && mutation!.isLoading;
  bool get isUpdating =>
      mutation?.type == MutationType.update && mutation!.isLoading;
  bool get isDeleting =>
      mutation?.type == MutationType.delete && mutation!.isLoading;
  bool get hasMutationSuccess => mutation?.isSuccess ?? false;
  bool get hasMutationError => mutation?.isError ?? false;
  String? get mutationMessage => mutation?.successMessage;
  Failure? get mutationFailure => mutation?.failure;

  // * Helper to clear mutation state after handled
  CategoriesState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      categories,
      mutatedCategory,
      categoriesFilter,
      isLoading,
      isLoadingMore,
      mutation,
      message,
      failure,
      cursor,
    ];
  }
}
