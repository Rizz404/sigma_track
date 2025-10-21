import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_cursor_usecase.dart';

// * State untuk mutation operation yang lebih descriptive
class LocationMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;

  const LocationMutationState({
    required this.type,
    this.isLoading = false,
    this.successMessage,
    this.failure,
  });

  bool get isSuccess => successMessage != null && failure == null;
  bool get isError => failure != null;

  @override
  List<Object?> get props => [type, isLoading, successMessage, failure];
}

class LocationsState extends Equatable {
  final List<Location> locations;
  final GetLocationsCursorUsecaseParams locationsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final LocationMutationState? mutation;
  final Failure? failure;
  final Cursor? cursor;

  const LocationsState({
    this.locations = const [],
    required this.locationsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.mutation,
    this.failure,
    this.cursor,
  });

  // * Computed properties untuk kemudahan di UI
  bool get isMutating => mutation?.isLoading ?? false;
  bool get isCreating =>
      mutation?.type == MutationType.create && mutation!.isLoading;
  bool get isUpdating =>
      mutation?.type == MutationType.update && mutation!.isLoading;
  bool get isDeleting =>
      mutation?.type == MutationType.delete && mutation!.isLoading;
  bool get hasMutationSuccess => mutation?.isSuccess ?? false;
  bool get hasMutationError => mutation?.isError ?? false;
  String? get mutationMessage => mutation?.successMessage;
  Failure? get mutationFailure => mutation?.failure;

  // * Factory methods yang lebih descriptive
  factory LocationsState.initial() => LocationsState(
    locationsFilter: GetLocationsCursorUsecaseParams(),
    isLoading: true,
  );

  factory LocationsState.loading({
    required GetLocationsCursorUsecaseParams locationsFilter,
    List<Location>? currentLocations,
  }) => LocationsState(
    locations: currentLocations ?? const [],
    locationsFilter: locationsFilter,
    isLoading: true,
  );

  factory LocationsState.success({
    required List<Location> locations,
    required GetLocationsCursorUsecaseParams locationsFilter,
    Cursor? cursor,
  }) => LocationsState(
    locations: locations,
    locationsFilter: locationsFilter,
    cursor: cursor,
  );

  factory LocationsState.error({
    required Failure failure,
    required GetLocationsCursorUsecaseParams locationsFilter,
    List<Location>? currentLocations,
  }) => LocationsState(
    locations: currentLocations ?? const [],
    locationsFilter: locationsFilter,
    failure: failure,
  );

  factory LocationsState.loadingMore({
    required List<Location> currentLocations,
    required GetLocationsCursorUsecaseParams locationsFilter,
    Cursor? cursor,
  }) => LocationsState(
    locations: currentLocations,
    locationsFilter: locationsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Factory methods untuk mutation states
  factory LocationsState.creating({
    required List<Location> currentLocations,
    required GetLocationsCursorUsecaseParams locationsFilter,
    Cursor? cursor,
  }) => LocationsState(
    locations: currentLocations,
    locationsFilter: locationsFilter,
    cursor: cursor,
    mutation: const LocationMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory LocationsState.updating({
    required List<Location> currentLocations,
    required GetLocationsCursorUsecaseParams locationsFilter,
    Cursor? cursor,
  }) => LocationsState(
    locations: currentLocations,
    locationsFilter: locationsFilter,
    cursor: cursor,
    mutation: const LocationMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory LocationsState.deleting({
    required List<Location> currentLocations,
    required GetLocationsCursorUsecaseParams locationsFilter,
    Cursor? cursor,
  }) => LocationsState(
    locations: currentLocations,
    locationsFilter: locationsFilter,
    cursor: cursor,
    mutation: const LocationMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory LocationsState.mutationSuccess({
    required List<Location> locations,
    required GetLocationsCursorUsecaseParams locationsFilter,
    required MutationType mutationType,
    required String message,
    Cursor? cursor,
  }) => LocationsState(
    locations: locations,
    locationsFilter: locationsFilter,
    cursor: cursor,
    mutation: LocationMutationState(
      type: mutationType,
      successMessage: message,
    ),
  );

  factory LocationsState.mutationError({
    required List<Location> currentLocations,
    required GetLocationsCursorUsecaseParams locationsFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => LocationsState(
    locations: currentLocations,
    locationsFilter: locationsFilter,
    cursor: cursor,
    mutation: LocationMutationState(type: mutationType, failure: failure),
  );

  LocationsState copyWith({
    List<Location>? locations,
    GetLocationsCursorUsecaseParams? locationsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<LocationMutationState?>? mutation,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return LocationsState(
      locations: locations ?? this.locations,
      locationsFilter: locationsFilter ?? this.locationsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      mutation: mutation != null ? mutation() : this.mutation,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Helper untuk clear mutation state setelah handled
  LocationsState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      locations,
      locationsFilter,
      isLoading,
      isLoadingMore,
      mutation,
      failure,
      cursor,
    ];
  }
}
