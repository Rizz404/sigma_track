import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_by_name_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_detail_state.dart';

class GetUserByNameNotifier
    extends AutoDisposeFamilyNotifier<UserDetailState, String> {
  GetUserByNameUsecase get _getUserByNameUsecase =>
      ref.watch(getUserByNameUsecaseProvider);

  @override
  UserDetailState build(String name) {
    // * Cache user detail for 3 minutes (detail view use case)
    ref.cacheFor(const Duration(minutes: 3));
    this.logPresentation('Loading user by name: $name');
    _loadUser(name);
    return UserDetailState.initial();
  }

  Future<void> _loadUser(String name) async {
    state = UserDetailState.loading();

    final result = await _getUserByNameUsecase.call(
      GetUserByNameUsecaseParams(name: name),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load user by name', failure);
        state = UserDetailState.error(failure);
      },
      (success) {
        this.logData('User loaded by name: ${success.data?.name}');
        if (success.data != null) {
          state = UserDetailState.success(success.data!);
        } else {
          state = UserDetailState.error(
            const ServerFailure(message: 'User not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadUser(arg);
  }
}
