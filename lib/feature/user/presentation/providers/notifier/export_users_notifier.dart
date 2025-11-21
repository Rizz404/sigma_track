import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/export_user_list_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/export_users_state.dart';

class ExportUsersNotifier extends AutoDisposeNotifier<ExportUsersState> {
  ExportUserListUsecase get _exportUserListUsecase =>
      ref.watch(exportUserListUsecaseProvider);

  @override
  ExportUsersState build() {
    this.logPresentation('Initializing ExportUsersNotifier');
    return ExportUsersState.initial();
  }

  void reset() {
    this.logPresentation('Resetting export state');
    state = ExportUsersState.initial();
  }

  Future<void> exportUsers(ExportUserListUsecaseParams params) async {
    this.logPresentation('Exporting users with params: $params');

    state = state.copyWith(
      isLoading: true,
      failure: null,
      message: null,
      previewData: null,
    );

    final result = await _exportUserListUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to export users', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) async {
        this.logData('Users exported successfully');
        state = state.copyWith(
          isLoading: false,
          previewData: success.data,
          message: 'Export preview generated successfully',
        );
      },
    );
  }
}
