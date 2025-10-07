import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_by_email_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_detail_state.dart';

class GetUserByEmailNotifier
    extends AutoDisposeFamilyNotifier<UserDetailState, String> {
  GetUserByEmailUsecase get _getUserByEmailUsecase =>
      ref.watch(getUserByEmailUsecaseProvider);

  @override
  UserDetailState build(String email) {
    this.logPresentation('Loading user by email: $email');
    _loadUser(email);
    return UserDetailState.initial();
  }

  Future<void> _loadUser(String email) async {
    state = UserDetailState.loading();

    final result = await _getUserByEmailUsecase.call(
      GetUserByEmailUsecaseParams(email: email),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load user by email', failure);
        state = UserDetailState.error(failure);
      },
      (success) {
        this.logData('User loaded by email: ${success.data?.name}');
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
