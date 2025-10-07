import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';

// * State untuk single location (getById, getByCode)
class LocationDetailState extends Equatable {
  final Location? location;
  final bool isLoading;
  final Failure? failure;

  const LocationDetailState({
    this.location,
    this.isLoading = false,
    this.failure,
  });

  factory LocationDetailState.initial() =>
      const LocationDetailState(isLoading: true);

  factory LocationDetailState.loading() =>
      const LocationDetailState(isLoading: true);

  factory LocationDetailState.success(Location location) =>
      LocationDetailState(location: location);

  factory LocationDetailState.error(Failure failure) =>
      LocationDetailState(failure: failure);

  LocationDetailState copyWith({
    Location? location,
    bool? isLoading,
    Failure? failure,
  }) {
    return LocationDetailState(
      location: location ?? this.location,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [location, isLoading, failure];
}
