import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';

class LocationsFilter extends Equatable {
  final String? search;
  final LocationSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  LocationsFilter({
    this.search,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  LocationsFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<LocationSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return LocationsFilter(
      search: search != null ? search() : this.search,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  @override
  List<Object?> get props {
    return [search, sortBy, sortOrder, cursor, limit];
  }

  @override
  String toString() {
    return 'LocationsFilter(search: $search, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';
  }
}

class LocationsState extends Equatable {
  final List<Location> locations;
  final Location? mutatedLocation;
  final LocationsFilter locationsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const LocationsState({
    this.locations = const [],
    this.mutatedLocation,
    required this.locationsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory LocationsState.initial() =>
      LocationsState(locationsFilter: LocationsFilter(), isLoading: true);

  factory LocationsState.loading({
    required LocationsFilter locationsFilter,
    List<Location>? currentLocations,
  }) => LocationsState(
    locations: currentLocations ?? const [],
    locationsFilter: locationsFilter,
    isLoading: true,
  );

  factory LocationsState.success({
    required List<Location> locations,
    required LocationsFilter locationsFilter,
    Cursor? cursor,
    String? message,
    Location? mutatedLocation,
  }) => LocationsState(
    locations: locations,
    locationsFilter: locationsFilter,
    cursor: cursor,
    message: message,
    mutatedLocation: mutatedLocation,
  );

  factory LocationsState.error({
    required Failure failure,
    required LocationsFilter locationsFilter,
    List<Location>? currentLocations,
  }) => LocationsState(
    locations: currentLocations ?? const [],
    locationsFilter: locationsFilter,
    failure: failure,
  );

  factory LocationsState.loadingMore({
    required List<Location> currentLocations,
    required LocationsFilter locationsFilter,
    Cursor? cursor,
  }) => LocationsState(
    locations: currentLocations,
    locationsFilter: locationsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  LocationsState copyWith({
    List<Location>? locations,
    ValueGetter<Location?>? mutatedLocation,
    LocationsFilter? locationsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return LocationsState(
      locations: locations ?? this.locations,
      mutatedLocation: mutatedLocation != null
          ? mutatedLocation()
          : this.mutatedLocation,
      locationsFilter: locationsFilter ?? this.locationsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMutating: isMutating ?? this.isMutating,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  @override
  List<Object?> get props {
    return [
      locations,
      mutatedLocation,
      locationsFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
