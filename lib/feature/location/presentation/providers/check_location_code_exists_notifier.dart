import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_code_exists_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_boolean_state.dart';

class CheckLocationCodeExistsNotifier
    extends AutoDisposeFamilyNotifier<LocationBooleanState, String> {
  CheckLocationCodeExistsUsecase get _checkLocationCodeExistsUsecase =>
      ref.watch(checkLocationCodeExistsUsecaseProvider);

  @override
  LocationBooleanState build(String code) {
    // * Cache validation for 30 seconds (form validation use case)
    ref.cacheFor(const Duration(seconds: 30));
    this.logPresentation('Checking if location code exists: $code');
    _checkCodeExists(code);
    return LocationBooleanState.initial();
  }

  Future<void> _checkCodeExists(String code) async {
    state = LocationBooleanState.loading();

    final result = await _checkLocationCodeExistsUsecase.call(
      CheckLocationCodeExistsUsecaseParams(code: code),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check location code', failure);
        state = LocationBooleanState.error(failure);
      },
      (success) {
        this.logData('Location code exists: ${success.data}');
        state = LocationBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkCodeExists(arg);
  }
}
