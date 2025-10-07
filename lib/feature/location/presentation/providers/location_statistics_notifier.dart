import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_statistics_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_statistics_state.dart';

class LocationStatisticsNotifier
    extends AutoDisposeNotifier<LocationStatisticsState> {
  GetLocationsStatisticsUsecase get _getLocationsStatisticsUsecase =>
      ref.watch(getLocationsStatisticsUsecaseProvider);

  @override
  LocationStatisticsState build() {
    this.logPresentation('Loading location statistics');
    _loadStatistics();
    return LocationStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = LocationStatisticsState.loading();

    final result = await _getLocationsStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load location statistics', failure);
        state = LocationStatisticsState.error(failure);
      },
      (success) {
        this.logData('Location statistics loaded');
        if (success.data != null) {
          state = LocationStatisticsState.success(success.data!);
        } else {
          state = LocationStatisticsState.error(
            const ServerFailure(message: 'No statistics data'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadStatistics();
  }
}
