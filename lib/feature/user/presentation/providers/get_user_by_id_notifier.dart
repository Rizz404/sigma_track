import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_detail_state.dart';

class GetUserByIdNotifier
    extends AutoDisposeFamilyNotifier<UserDetailState, String> {
  GetUserByIdUsecase get _getUserByIdUsecase =>
      ref.watch(getUserByIdUsecaseProvider);

  @override
  UserDetailState build(String id) {
    this.logPresentation('Loading user by id: $id');
    _loadUser(id);
    return UserDetailState.initial();
  }

  Future<void> _loadUser(String id) async {
    state = UserDetailState.loading();

    final result = await _getUserByIdUsecase.call(
      GetUserByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load user by id', failure);
        state = UserDetailState.error(failure);
      },
      (success) {
        this.logData('User loaded by id: ${success.data?.name}');
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
