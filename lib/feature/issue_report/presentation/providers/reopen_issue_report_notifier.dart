import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/reopen_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_detail_state.dart';

class ReopenIssueReportNotifier
    extends AutoDisposeNotifier<IssueReportDetailState> {
  ReopenIssueReportUsecase get _reopenIssueReportUsecase =>
      ref.watch(reopenIssueReportUsecaseProvider);

  @override
  IssueReportDetailState build() {
    this.logPresentation('Initializing ReopenIssueReportNotifier');
    return IssueReportDetailState.initial();
  }

  Future<void> reopenIssueReport(String id) async {
    this.logPresentation('Reopening issue report: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _reopenIssueReportUsecase.call(
      ReopenIssueReportUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to reopen issue report',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully reopened issue report');
        state = state.copyWith(
          isLoading: false,
          issueReport: success.data,
          failure: null,
        );
      },
    );
  }
}
