import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk usecase yang return bool (checkExists)
class ScanLogBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const ScanLogBooleanState({
    this.result,
    this.isLoading = false,
    this.failure,
  });

  factory ScanLogBooleanState.initial() =>
      const ScanLogBooleanState(isLoading: true);

  factory ScanLogBooleanState.loading() =>
      const ScanLogBooleanState(isLoading: true);

  factory ScanLogBooleanState.success(bool result) =>
      ScanLogBooleanState(result: result);

  factory ScanLogBooleanState.error(Failure failure) =>
      ScanLogBooleanState(failure: failure);

  ScanLogBooleanState copyWith({
    bool? result,
    bool? isLoading,
    Failure? failure,
  }) {
    return ScanLogBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
