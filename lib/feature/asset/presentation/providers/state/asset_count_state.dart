import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk countAssets usecase
class AssetCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const AssetCountState({this.count, this.isLoading = false, this.failure});

  factory AssetCountState.initial() => const AssetCountState(isLoading: true);

  factory AssetCountState.loading() => const AssetCountState(isLoading: true);

  factory AssetCountState.success(int count) => AssetCountState(count: count);

  factory AssetCountState.error(Failure failure) =>
      AssetCountState(failure: failure);

  AssetCountState copyWith({int? count, bool? isLoading, Failure? failure}) {
    return AssetCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
