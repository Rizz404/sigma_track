import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';

enum LocationStatus { initial, loading, error, success }

class LocationMutationState extends Equatable {
  final LocationStatus locationStatus;
  final Location? location;
  final String? message;
  final Failure? failure;

  const LocationMutationState({
    required this.locationStatus,
    this.location,
    this.message,
    this.failure,
  });

  factory LocationMutationState.success({Location? location, String? message}) {
    return LocationMutationState(
      locationStatus: LocationStatus.success,
      location: location,
      message: message,
    );
  }

  factory LocationMutationState.error({Failure? failure}) {
    return LocationMutationState(
      locationStatus: LocationStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }

  LocationMutationState copyWith({
    LocationStatus? locationStatus,
    ValueGetter<Location?>? location,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return LocationMutationState(
      locationStatus: locationStatus ?? this.locationStatus,
      location: location != null ? location() : this.location,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [locationStatus, location, message, failure];
}
