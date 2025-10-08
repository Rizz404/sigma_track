import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/category/domain/usecases/count_categories_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/categories_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/categories_search_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_statistics_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/check_category_code_exists_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/check_category_exists_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/count_categories_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/get_category_by_code_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/get_category_by_id_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_boolean_state.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_count_state.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_detail_state.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_statistics_state.dart';

// * Main list provider untuk kategori (cursor pagination)
final categoriesProvider =
    AutoDisposeNotifierProvider<CategoriesNotifier, CategoriesState>(
      CategoriesNotifier.new,
    );

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final categoriesSearchProvider =
    AutoDisposeNotifierProvider<CategoriesSearchNotifier, CategoriesState>(
      CategoriesSearchNotifier.new,
    );

// * Provider untuk check apakah category code exists
final checkCategoryCodeExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckCategoryCodeExistsNotifier,
      CategoryBooleanState,
      String
    >(CheckCategoryCodeExistsNotifier.new);

// * Provider untuk check apakah category exists by ID
final checkCategoryExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckCategoryExistsNotifier,
      CategoryBooleanState,
      String
    >(CheckCategoryExistsNotifier.new);

// * Provider untuk count categories
final countCategoriesProvider =
    AutoDisposeNotifierProviderFamily<
      CountCategoriesNotifier,
      CategoryCountState,
      CountCategoriesUsecaseParams
    >(CountCategoriesNotifier.new);

// * Provider untuk category statistics
final categoryStatisticsProvider =
    AutoDisposeNotifierProvider<
      CategoryStatisticsNotifier,
      CategoryStatisticsState
    >(CategoryStatisticsNotifier.new);

// * Provider untuk get category by code
final getCategoryByCodeProvider =
    AutoDisposeNotifierProviderFamily<
      GetCategoryByCodeNotifier,
      CategoryDetailState,
      String
    >(GetCategoryByCodeNotifier.new);

// * Provider untuk get category by ID
final getCategoryByIdProvider =
    AutoDisposeNotifierProviderFamily<
      GetCategoryByIdNotifier,
      CategoryDetailState,
      String
    >(GetCategoryByIdNotifier.new);
