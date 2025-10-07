import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';

// * State untuk single category (getById, getByCode)
class CategoryDetailState extends Equatable {
  final Category? category;
  final bool isLoading;
  final Failure? failure;

  const CategoryDetailState({
    this.category,
    this.isLoading = false,
    this.failure,
  });

  factory CategoryDetailState.initial() =>
      const CategoryDetailState(isLoading: true);

  factory CategoryDetailState.loading() =>
      const CategoryDetailState(isLoading: true);

  factory CategoryDetailState.success(Category category) =>
      CategoryDetailState(category: category);

  factory CategoryDetailState.error(Failure failure) =>
      CategoryDetailState(failure: failure);

  CategoryDetailState copyWith({
    Category? category,
    bool? isLoading,
    Failure? failure,
  }) {
    return CategoryDetailState(
      category: category ?? this.category,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [category, isLoading, failure];
}
