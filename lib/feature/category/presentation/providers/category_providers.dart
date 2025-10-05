import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/category/presentation/providers/categories_notifier.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';

final categoriesProvider =
    AutoDisposeNotifierProvider<CategoriesNotifier, CategoriesState>(
      CategoriesNotifier.new,
    );
