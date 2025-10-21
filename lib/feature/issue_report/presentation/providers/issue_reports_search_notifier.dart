import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_cursor_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_reports_state.dart';

class IssueReportsSearchNotifier
    extends AutoDisposeNotifier<IssueReportsState> {
  GetIssueReportsCursorUsecase get _getIssueReportsCursorUsecase =>
      ref.watch(getIssueReportsCursorUsecaseProvider);

  @override
  IssueReportsState build() {
    // * Cache search results for 2 minutes (dropdown use case)
    ref.cacheFor(const Duration(minutes: 2));
    this.logPresentation('Initializing IssueReportsSearchNotifier');
    return IssueReportsState.initial();
  }

  Future<IssueReportsState> _loadIssueReports({
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
  }) async {
    this.logPresentation(
      'Loading issue reports with filter: $issueReportsFilter',
    );

    final result = await _getIssueReportsCursorUsecase.call(
      GetIssueReportsCursorUsecaseParams(
        search: issueReportsFilter.search,
        assetId: issueReportsFilter.assetId,
        reportedBy: issueReportsFilter.reportedBy,
        resolvedBy: issueReportsFilter.resolvedBy,
        issueType: issueReportsFilter.issueType,
        priority: issueReportsFilter.priority,
        status: issueReportsFilter.status,
        isResolved: issueReportsFilter.isResolved,
        dateFrom: issueReportsFilter.dateFrom,
        dateTo: issueReportsFilter.dateTo,
        sortBy: issueReportsFilter.sortBy,
        sortOrder: issueReportsFilter.sortOrder,
        cursor: issueReportsFilter.cursor,
        limit: issueReportsFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load issue reports', failure);
        return IssueReportsState.error(
          failure: failure,
          issueReportsFilter: issueReportsFilter,
          currentIssueReports: null,
        );
      },
      (success) {
        this.logData(
          'Issue reports loaded: ${success.data?.length ?? 0} items',
        );
        return IssueReportsState.success(
          issueReports: success.data as List<IssueReport>,
          issueReportsFilter: issueReportsFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching issue reports: $search');

    final newFilter = state.issueReportsFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadIssueReports(issueReportsFilter: newFilter);
  }

  void clear() {
    this.logPresentation('Clearing search results');
    state = IssueReportsState.initial();
  }
}
