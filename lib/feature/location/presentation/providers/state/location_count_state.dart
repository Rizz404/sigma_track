import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk countLocations usecase
class LocationCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const LocationCountState({this.count, this.isLoading = false, this.failure});

  factory LocationCountState.initial() =>
      const LocationCountState(isLoading: true);

  factory LocationCountState.loading() =>
      const LocationCountState(isLoading: true);

  factory LocationCountState.success(int count) =>
      LocationCountState(count: count);

  factory LocationCountState.error(Failure failure) =>
      LocationCountState(failure: failure);

  LocationCountState copyWith({int? count, bool? isLoading, Failure? failure}) {
    return LocationCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
