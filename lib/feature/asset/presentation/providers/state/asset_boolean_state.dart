import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk usecase yang return bool (checkExists, checkSerialExists, checkTagExists)
class AssetBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const AssetBooleanState({this.result, this.isLoading = false, this.failure});

  factory AssetBooleanState.initial() =>
      const AssetBooleanState(isLoading: true);

  factory AssetBooleanState.loading() =>
      const AssetBooleanState(isLoading: true);

  factory AssetBooleanState.success(bool result) =>
      AssetBooleanState(result: result);

  factory AssetBooleanState.error(Failure failure) =>
      AssetBooleanState(failure: failure);

  AssetBooleanState copyWith({
    bool? result,
    bool? isLoading,
    Failure? failure,
  }) {
    return AssetBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
