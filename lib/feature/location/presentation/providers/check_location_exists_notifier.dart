import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_exists_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_boolean_state.dart';

class CheckLocationExistsNotifier
    extends AutoDisposeFamilyNotifier<LocationBooleanState, String> {
  CheckLocationExistsUsecase get _checkLocationExistsUsecase =>
      ref.watch(checkLocationExistsUsecaseProvider);

  @override
  LocationBooleanState build(String id) {
    this.logPresentation('Checking if location exists: $id');
    _checkExists(id);
    return LocationBooleanState.initial();
  }

  Future<void> _checkExists(String id) async {
    state = LocationBooleanState.loading();

    final result = await _checkLocationExistsUsecase.call(
      CheckLocationExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check location exists', failure);
        state = LocationBooleanState.error(failure);
      },
      (success) {
        this.logData('Location exists: ${success.data}');
        state = LocationBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkExists(arg);
  }
}
