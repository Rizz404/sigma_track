import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_code_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_detail_state.dart';

class GetLocationByCodeNotifier
    extends AutoDisposeFamilyNotifier<LocationDetailState, String> {
  GetLocationByCodeUsecase get _getLocationByCodeUsecase =>
      ref.watch(getLocationByCodeUsecaseProvider);

  @override
  LocationDetailState build(String code) {
    // * Cache location detail for 3 minutes (detail view use case)
    ref.cacheFor(const Duration(minutes: 3));
    this.logPresentation('Loading location by code: $code');
    _loadLocation(code);
    return LocationDetailState.initial();
  }

  Future<void> _loadLocation(String code) async {
    state = LocationDetailState.loading();

    final result = await _getLocationByCodeUsecase.call(
      GetLocationByCodeUsecaseParams(code: code),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load location by code', failure);
        state = LocationDetailState.error(failure);
      },
      (success) {
        this.logData('Location loaded by code: ${success.data?.locationName}');
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
