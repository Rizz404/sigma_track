import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/location/domain/usecases/count_locations_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_count_state.dart';

class CountLocationsNotifier
    extends
        AutoDisposeFamilyNotifier<
          LocationCountState,
          CountLocationsUsecaseParams
        > {
  CountLocationsUsecase get _countLocationsUsecase =>
      ref.watch(countLocationsUsecaseProvider);

  @override
  LocationCountState build(CountLocationsUsecaseParams params) {
    this.logPresentation('Counting locations with params: $params');
    _countLocations(params);
    return LocationCountState.initial();
  }

  Future<void> _countLocations(CountLocationsUsecaseParams params) async {
    state = LocationCountState.loading();

    final result = await _countLocationsUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to count locations', failure);
        state = LocationCountState.error(failure);
      },
      (success) {
        this.logData('Locations count: ${success.data}');
        state = LocationCountState.success(success.data ?? 0);
      },
    );
  }

  Future<void> refresh() async {
    await _countLocations(arg);
  }
}
