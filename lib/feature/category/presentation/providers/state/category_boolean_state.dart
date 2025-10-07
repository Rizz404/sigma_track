import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk usecase yang return bool (checkExists, checkCodeExists)
class CategoryBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const CategoryBooleanState({
    this.result,
    this.isLoading = false,
    this.failure,
  });

  factory CategoryBooleanState.initial() =>
      const CategoryBooleanState(isLoading: true);

  factory CategoryBooleanState.loading() =>
      const CategoryBooleanState(isLoading: true);

  factory CategoryBooleanState.success(bool result) =>
      CategoryBooleanState(result: result);

  factory CategoryBooleanState.error(Failure failure) =>
      CategoryBooleanState(failure: failure);

  CategoryBooleanState copyWith({
    bool? result,
    bool? isLoading,
    Failure? failure,
  }) {
    return CategoryBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
