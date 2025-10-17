import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/usecases/create_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/delete_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_cursor_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/update_location_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/locations_state.dart';

class LocationsNotifier extends AutoDisposeNotifier<LocationsState> {
  GetLocationsCursorUsecase get _getLocationsCursorUsecase =>
      ref.watch(getLocationsCursorUsecaseProvider);
  CreateLocationUsecase get _createLocationUsecase =>
      ref.watch(createLocationUsecaseProvider);
  UpdateLocationUsecase get _updateLocationUsecase =>
      ref.watch(updateLocationUsecaseProvider);
  DeleteLocationUsecase get _deleteLocationUsecase =>
      ref.watch(deleteLocationUsecaseProvider);

  @override
  LocationsState build() {
    this.logPresentation('Initializing LocationsNotifier');
    _initializeLocations();
    return LocationsState.initial();
  }

  Future<void> _initializeLocations() async {
    state = await _loadLocations(locationsFilter: LocationsFilter());
  }

  Future<LocationsState> _loadLocations({
    required LocationsFilter locationsFilter,
    List<Location>? currentLocations,
  }) async {
    this.logPresentation('Loading locations with filter: $locationsFilter');

    final result = await _getLocationsCursorUsecase.call(
      GetLocationsCursorUsecaseParams(
        search: locationsFilter.search,
        sortBy: locationsFilter.sortBy,
        sortOrder: locationsFilter.sortOrder,
        cursor: locationsFilter.cursor,
        limit: locationsFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load locations', failure);
        return LocationsState.error(
          failure: failure,
          locationsFilter: locationsFilter,
          currentLocations: currentLocations,
        );
      },
      (success) {
        this.logData('Locations loaded: ${success.data?.length ?? 0} items');
        return LocationsState.success(
          locations: (success.data ?? []).cast<Location>(),
          locationsFilter: locationsFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching locations: $search');

    final newFilter = state.locationsFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadLocations(locationsFilter: newFilter);
  }

  Future<void> updateFilter(LocationsFilter newFilter) async {
    this.logPresentation('Updating filter: $newFilter');

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.locationsFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadLocations(locationsFilter: filterWithResetCursor);
  }

  Future<void> loadMore() async {
    if (state.cursor == null || !state.cursor!.hasNextPage) {
      this.logPresentation('No more pages to load');
      return;
    }

    if (state.isLoadingMore) {
      this.logPresentation('Already loading more');
      return;
    }

    this.logPresentation('Loading more locations');

    state = LocationsState.loadingMore(
      currentLocations: state.locations,
      locationsFilter: state.locationsFilter,
      cursor: state.cursor,
    );

    final newFilter = state.locationsFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getLocationsCursorUsecase.call(
      GetLocationsCursorUsecaseParams(
        search: newFilter.search,
        sortBy: newFilter.sortBy,
        sortOrder: newFilter.sortOrder,
        cursor: newFilter.cursor,
        limit: newFilter.limit,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load more locations', failure);
        state = LocationsState.error(
          failure: failure,
          locationsFilter: newFilter,
          currentLocations: state.locations,
        );
      },
      (success) {
        this.logData('More locations loaded: ${success.data?.length ?? 0}');
        state = LocationsState.success(
          locations: [
            ...state.locations,
            ...(success.data ?? []).cast<Location>(),
          ],
          locationsFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> createLocation(CreateLocationUsecaseParams params) async {
    this.logPresentation('Creating location');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _createLocationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create location', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Location created successfully');

        state = state.copyWith(
          message: () => success.message ?? 'Location created',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadLocations(locationsFilter: state.locationsFilter);
      },
    );
  }

  Future<void> updateLocation(UpdateLocationUsecaseParams params) async {
    this.logPresentation('Updating location: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _updateLocationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update location', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Location updated successfully');

        state = state.copyWith(
          message: () => success.message ?? 'Location updated',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadLocations(locationsFilter: state.locationsFilter);
      },
    );
  }

  Future<void> deleteLocation(DeleteLocationUsecaseParams params) async {
    this.logPresentation('Deleting location: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _deleteLocationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete location', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Location deleted successfully');

        state = state.copyWith(
          message: () => success.message ?? 'Location deleted',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadLocations(locationsFilter: state.locationsFilter);
      },
    );
  }

  Future<void> deleteManyLocations(List<String> locationIds) async {
    this.logPresentation('Deleting ${locationIds.length} locations');

    // Todo: Tunggu backend impl
    await refresh();
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.locationsFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadLocations(locationsFilter: currentFilter);
  }
}
