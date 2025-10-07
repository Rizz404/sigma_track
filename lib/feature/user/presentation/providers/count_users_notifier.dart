import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/count_users_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_count_state.dart';

class CountUsersNotifier
    extends AutoDisposeFamilyNotifier<UserCountState, CountUsersUsecaseParams> {
  CountUsersUsecase get _countUsersUsecase =>
      ref.watch(countUsersUsecaseProvider);

  @override
  UserCountState build(CountUsersUsecaseParams params) {
    this.logPresentation('Counting users with params: $params');
    _countUsers(params);
    return UserCountState.initial();
  }

  Future<void> _countUsers(CountUsersUsecaseParams params) async {
    state = UserCountState.loading();

    final result = await _countUsersUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to count users', failure);
        state = UserCountState.error(failure);
      },
      (success) {
        this.logData('Users count: ${success.data}');
        state = UserCountState.success(success.data ?? 0);
      },
    );
  }

  Future<void> refresh() async {
    await _countUsers(arg);
  }
}
