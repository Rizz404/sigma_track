import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';

enum CategoryStatus { initial, loading, error, success }

class CategoryMutationState {
  final CategoryStatus categoryStatus;
  final Category? category;
  final String? message;
  final Failure? failure;

  const CategoryMutationState({
    required this.categoryStatus,
    this.category,
    this.message,
    this.failure,
  });

  factory CategoryMutationState.success({Category? category, String? message}) {
    return CategoryMutationState(
      categoryStatus: CategoryStatus.success,
      category: category,
      message: message,
    );
  }

  factory CategoryMutationState.error({Failure? failure}) {
    return CategoryMutationState(
      categoryStatus: CategoryStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }
}
