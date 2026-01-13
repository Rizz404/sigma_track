import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_cursor_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/locations_state.dart';

class LocationsSearchDropdownNotifier
    extends AutoDisposeNotifier<LocationsState> {
  GetLocationsCursorUsecase get _getLocationsCursorUsecase =>
      ref.watch(getLocationsCursorUsecaseProvider);

  @override
  LocationsState build() {
    // * Cache search results for 2 minutes (dropdown use case)
    ref.cacheFor(const Duration(minutes: 2));
    this.logPresentation('Initializing LocationsSearchDropdownNotifier');
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
          currentLocations: null,
        );
      },
      (success) {
        this.logData('Locations loaded: ${success.data?.length ?? 0} items');
        return LocationsState.success(
          locations: success.data ?? [],
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

  void clear() {
    this.logPresentation('Clearing search results');
    state = LocationsState.initial();
  }
}
