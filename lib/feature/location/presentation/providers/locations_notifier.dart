import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';

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
    state = await _loadLocations(
      locationsFilter: GetLocationsCursorUsecaseParams(),
    );
  }

  Future<LocationsState> _loadLocations({
    required GetLocationsCursorUsecaseParams locationsFilter,
    List<Location>? currentLocations,
  }) async {
    this.logPresentation('Loading locations with filter: $locationsFilter');

    final result = await _getLocationsCursorUsecase.call(locationsFilter);

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

  Future<void> updateFilter(GetLocationsCursorUsecaseParams newFilter) async {
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

    state = LocationsState.creating(
      currentLocations: state.locations,
      locationsFilter: state.locationsFilter,
      cursor: state.cursor,
    );

    final result = await _createLocationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create location', failure);
        state = LocationsState.mutationError(
          currentLocations: state.locations,
          locationsFilter: state.locationsFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Location created successfully');

        // * Reload locations dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadLocations(
          locationsFilter: state.locationsFilter,
        );

        // * Set mutation success setelah reload
        state = LocationsState.mutationSuccess(
          locations: newState.locations,
          locationsFilter: newState.locationsFilter,
          mutationType: MutationType.create,
          message: success.message ?? 'Location created',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> updateLocation(UpdateLocationUsecaseParams params) async {
    this.logPresentation('Updating location: ${params.id}');

    state = LocationsState.updating(
      currentLocations: state.locations,
      locationsFilter: state.locationsFilter,
      cursor: state.cursor,
    );

    final result = await _updateLocationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update location', failure);
        state = LocationsState.mutationError(
          currentLocations: state.locations,
          locationsFilter: state.locationsFilter,
          mutationType: MutationType.update,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Location updated successfully');

        // * Reload locations dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadLocations(
          locationsFilter: state.locationsFilter,
        );

        // * Set mutation success setelah reload
        state = LocationsState.mutationSuccess(
          locations: newState.locations,
          locationsFilter: newState.locationsFilter,
          mutationType: MutationType.update,
          message: success.message ?? 'Location updated',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> deleteLocation(DeleteLocationUsecaseParams params) async {
    this.logPresentation('Deleting location: ${params.id}');

    state = LocationsState.deleting(
      currentLocations: state.locations,
      locationsFilter: state.locationsFilter,
      cursor: state.cursor,
    );

    final result = await _deleteLocationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete location', failure);
        state = LocationsState.mutationError(
          currentLocations: state.locations,
          locationsFilter: state.locationsFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Location deleted successfully');

        // * Reload locations dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadLocations(
          locationsFilter: state.locationsFilter,
        );

        // * Set mutation success setelah reload
        state = LocationsState.mutationSuccess(
          locations: newState.locations,
          locationsFilter: newState.locationsFilter,
          mutationType: MutationType.delete,
          message: success.message ?? 'Location deleted',
          cursor: newState.cursor,
        );
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
