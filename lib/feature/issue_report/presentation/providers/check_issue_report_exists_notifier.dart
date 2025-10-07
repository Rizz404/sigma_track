import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/check_issue_report_exists_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_boolean_state.dart';

class CheckIssueReportExistsNotifier
    extends AutoDisposeNotifier<IssueReportBooleanState> {
  CheckIssueReportExistsUsecase get _checkIssueReportExistsUsecase =>
      ref.watch(checkIssueReportExistsUsecaseProvider);

  @override
  IssueReportBooleanState build() {
    this.logPresentation('Initializing CheckIssueReportExistsNotifier');
    return IssueReportBooleanState.initial();
  }

  Future<void> checkIssueReportExists(String id) async {
    this.logPresentation('Checking if issue report exists: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _checkIssueReportExistsUsecase.call(
      CheckIssueReportExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to check issue report exists',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully checked issue report exists');
        state = state.copyWith(
          isLoading: false,
          result: success.data,
          failure: null,
        );
      },
    );
  }
}
