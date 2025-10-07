import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk usecase yang return bool (checkExists, checkCodeExists)
class LocationBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const LocationBooleanState({
    this.result,
    this.isLoading = false,
    this.failure,
  });

  factory LocationBooleanState.initial() =>
      const LocationBooleanState(isLoading: true);

  factory LocationBooleanState.loading() =>
      const LocationBooleanState(isLoading: true);

  factory LocationBooleanState.success(bool result) =>
      LocationBooleanState(result: result);

  factory LocationBooleanState.error(Failure failure) =>
      LocationBooleanState(failure: failure);

  LocationBooleanState copyWith({
    bool? result,
    bool? isLoading,
    Failure? failure,
  }) {
    return LocationBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
