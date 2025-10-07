import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk countScanLogs usecase
class ScanLogCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const ScanLogCountState({this.count, this.isLoading = false, this.failure});

  factory ScanLogCountState.initial() =>
      const ScanLogCountState(isLoading: true);

  factory ScanLogCountState.loading() =>
      const ScanLogCountState(isLoading: true);

  factory ScanLogCountState.success(int count) =>
      ScanLogCountState(count: count);

  factory ScanLogCountState.error(Failure failure) =>
      ScanLogCountState(failure: failure);

  ScanLogCountState copyWith({int? count, bool? isLoading, Failure? failure}) {
    return ScanLogCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
