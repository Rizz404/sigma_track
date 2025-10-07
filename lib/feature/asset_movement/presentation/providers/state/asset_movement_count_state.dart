import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';

class AssetMovementCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const AssetMovementCountState({
    this.count,
    this.isLoading = false,
    this.failure,
  });

  factory AssetMovementCountState.initial() => const AssetMovementCountState();

  AssetMovementCountState copyWith({
    int? count,
    bool? isLoading,
    Failure? failure,
  }) {
    return AssetMovementCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
