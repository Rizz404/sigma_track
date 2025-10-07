import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_statistics_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_statistics_state.dart';

class GetIssueReportsStatisticsNotifier
    extends AutoDisposeNotifier<IssueReportStatisticsState> {
  GetIssueReportsStatisticsUsecase get _getIssueReportsStatisticsUsecase =>
      ref.watch(getIssueReportsStatisticsUsecaseProvider);

  @override
  IssueReportStatisticsState build() {
    this.logPresentation('Initializing GetIssueReportsStatisticsNotifier');
    return IssueReportStatisticsState.initial();
  }

  Future<void> getIssueReportsStatistics() async {
    this.logPresentation('Getting issue reports statistics');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _getIssueReportsStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError(
          'Failed to get issue reports statistics',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully got issue reports statistics');
        state = state.copyWith(
          isLoading: false,
          statistics: success.data,
          failure: null,
        );
      },
    );
  }
}
