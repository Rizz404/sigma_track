import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_statistics_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_statistics_state.dart';

class IssueReportsStatisticsNotifier
    extends AutoDisposeNotifier<IssueReportStatisticsState> {
  GetIssueReportsStatisticsUsecase get _getIssueReportsStatisticsUsecase =>
      ref.watch(getIssueReportsStatisticsUsecaseProvider);

  @override
  IssueReportStatisticsState build() {
    // * Cache statistics for 5 minutes (dashboard use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading issue reports statistics');
    _loadStatistics();
    return IssueReportStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = IssueReportStatisticsState.loading();

    final result = await _getIssueReportsStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load issue reports statistics', failure);
        state = IssueReportStatisticsState.error(failure);
      },
      (success) {
        this.logData('Issue reports statistics loaded');
        if (success.data != null) {
          state = IssueReportStatisticsState.success(success.data!);
        } else {
          state = IssueReportStatisticsState.error(
            const ServerFailure(message: 'No statistics data'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadStatistics();
  }
}
