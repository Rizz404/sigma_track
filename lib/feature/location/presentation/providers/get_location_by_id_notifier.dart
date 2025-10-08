import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_id_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_detail_state.dart';

class GetLocationByIdNotifier
    extends AutoDisposeFamilyNotifier<LocationDetailState, String> {
  GetLocationByIdUsecase get _getLocationByIdUsecase =>
      ref.watch(getLocationByIdUsecaseProvider);

  @override
  LocationDetailState build(String id) {
    // * Cache location detail for 3 minutes (detail view use case)
    ref.cacheFor(const Duration(minutes: 3));
    this.logPresentation('Loading location by id: $id');
    _loadLocation(id);
    return LocationDetailState.initial();
  }

  Future<void> _loadLocation(String id) async {
    state = LocationDetailState.loading();

    final result = await _getLocationByIdUsecase.call(
      GetLocationByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load location by id', failure);
        state = LocationDetailState.error(failure);
      },
      (success) {
        this.logData('Location loaded by id: ${success.data?.locationName}');
        if (success.data != null) {
          state = LocationDetailState.success(success.data!);
        } else {
          state = LocationDetailState.error(
            const ServerFailure(message: 'Location not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadLocation(arg);
  }
}
