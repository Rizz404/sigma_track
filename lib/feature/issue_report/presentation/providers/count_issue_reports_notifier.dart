import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/count_issue_reports_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_count_state.dart';

class CountIssueReportsNotifier
    extends AutoDisposeNotifier<IssueReportCountState> {
  CountIssueReportsUsecase get _countIssueReportsUsecase =>
      ref.watch(countIssueReportsUsecaseProvider);

  @override
  IssueReportCountState build() {
    this.logPresentation('Initializing CountIssueReportsNotifier');
    return IssueReportCountState.initial();
  }

  Future<void> countIssueReports({
    IssueStatus? status,
    IssuePriority? priority,
  }) async {
    this.logPresentation('Counting issue reports with filters');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _countIssueReportsUsecase.call(
      CountIssueReportsUsecaseParams(status: status, priority: priority),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to count issue reports',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully counted issue reports');
        state = state.copyWith(
          isLoading: false,
          count: success.data,
          failure: null,
        );
      },
    );
  }
}
