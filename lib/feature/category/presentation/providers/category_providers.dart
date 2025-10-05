import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/category/presentation/providers/categories_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_mutation_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_mutation_state.dart';

final categoryMutationProvider =
    AutoDisposeNotifierProvider<
      CategoryMutationNotifier,
      CategoryMutationState
    >(CategoryMutationNotifier.new);

final categoresProvider =
    AutoDisposeNotifierProvider<CategoriesNotifier, CategoriesState>(
      CategoriesNotifier.new,
    );
