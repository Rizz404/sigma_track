import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/category/domain/entities/category_statistics.dart';

// * State untuk getCategoriesStatistics usecase
class CategoryStatisticsState extends Equatable {
  final CategoryStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const CategoryStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory CategoryStatisticsState.initial() =>
      const CategoryStatisticsState(isLoading: true);

  factory CategoryStatisticsState.loading() =>
      const CategoryStatisticsState(isLoading: true);

  factory CategoryStatisticsState.success(CategoryStatistics statistics) =>
      CategoryStatisticsState(statistics: statistics);

  factory CategoryStatisticsState.error(Failure failure) =>
      CategoryStatisticsState(failure: failure);

  CategoryStatisticsState copyWith({
    CategoryStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return CategoryStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
