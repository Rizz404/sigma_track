import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk countCategories usecase
class CategoryCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const CategoryCountState({this.count, this.isLoading = false, this.failure});

  factory CategoryCountState.initial() =>
      const CategoryCountState(isLoading: true);

  factory CategoryCountState.loading() =>
      const CategoryCountState(isLoading: true);

  factory CategoryCountState.success(int count) =>
      CategoryCountState(count: count);

  factory CategoryCountState.error(Failure failure) =>
      CategoryCountState(failure: failure);

  CategoryCountState copyWith({int? count, bool? isLoading, Failure? failure}) {
    return CategoryCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
