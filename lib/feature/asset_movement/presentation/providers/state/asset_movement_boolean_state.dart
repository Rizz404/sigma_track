import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';

class AssetMovementBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const AssetMovementBooleanState({
    this.result,
    this.isLoading = false,
    this.failure,
  });

  factory AssetMovementBooleanState.initial() =>
      const AssetMovementBooleanState();

  AssetMovementBooleanState copyWith({
    bool? result,
    bool? isLoading,
    Failure? failure,
  }) {
    return AssetMovementBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
