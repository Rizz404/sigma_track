import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';

enum CategoryStatus { initial, loading, error, success }

class CategoryMutationState extends Equatable {
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

  CategoryMutationState copyWith({
    CategoryStatus? categoryStatus,
    ValueGetter<Category?>? category,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return CategoryMutationState(
      categoryStatus: categoryStatus ?? this.categoryStatus,
      category: category != null ? category() : this.category,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [categoryStatus, category, message, failure];
}
