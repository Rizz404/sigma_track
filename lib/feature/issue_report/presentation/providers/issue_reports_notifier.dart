import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/bulk_create_issue_reports_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/bulk_delete_issue_reports_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/create_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/delete_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_cursor_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/update_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_reports_state.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';

class IssueReportsNotifier extends AutoDisposeNotifier<IssueReportsState> {
  GetIssueReportsCursorUsecase get _getIssueReportsCursorUsecase =>
      ref.watch(getIssueReportsCursorUsecaseProvider);
  CreateIssueReportUsecase get _createIssueReportUsecase =>
      ref.watch(createIssueReportUsecaseProvider);
  UpdateIssueReportUsecase get _updateIssueReportUsecase =>
      ref.watch(updateIssueReportUsecaseProvider);
  DeleteIssueReportUsecase get _deleteIssueReportUsecase =>
      ref.watch(deleteIssueReportUsecaseProvider);
  BulkCreateIssueReportsUsecase get _bulkCreateIssueReportsUsecase =>
      ref.watch(bulkCreateIssueReportsUsecaseProvider);
  BulkDeleteIssueReportsUsecase get _bulkDeleteIssueReportsUsecase =>
      ref.watch(bulkDeleteIssueReportsUsecaseProvider);

  @override
  IssueReportsState build() {
    this.logPresentation('Initializing IssueReportsNotifier');
    _initializeIssueReports();
    return IssueReportsState.initial();
  }

  Future<void> _initializeIssueReports() async {
    state = await _loadIssueReports(
      issueReportsFilter: const GetIssueReportsCursorUsecaseParams(),
    );
  }

  Future<IssueReportsState> _loadIssueReports({
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    List<IssueReport>? currentIssueReports,
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
          currentIssueReports: currentIssueReports,
        );
      },
      (success) {
        this.logData(
          'Issue reports loaded: ${success.data?.length ?? 0} items',
        );
        return IssueReportsState.success(
          issueReports: (success.data ?? []).cast<IssueReport>(),
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

  Future<void> updateFilter(
    GetIssueReportsCursorUsecaseParams newFilter,
  ) async {
    this.logPresentation('Updating filter: $newFilter');

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.issueReportsFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadIssueReports(issueReportsFilter: filterWithResetCursor);
  }

  Future<void> loadMore() async {
    if (state.cursor == null || !state.cursor!.hasNextPage) {
      this.logPresentation('No more pages to load');
      return;
    }

    if (state.isLoadingMore) {
      this.logPresentation('Already loading more');
      return;
    }

    this.logPresentation('Loading more issue reports');

    state = IssueReportsState.loadingMore(
      currentIssueReports: state.issueReports,
      issueReportsFilter: state.issueReportsFilter,
      cursor: state.cursor,
    );

    final newFilter = state.issueReportsFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getIssueReportsCursorUsecase.call(
      GetIssueReportsCursorUsecaseParams(
        search: newFilter.search,
        assetId: newFilter.assetId,
        reportedBy: newFilter.reportedBy,
        resolvedBy: newFilter.resolvedBy,
        issueType: newFilter.issueType,
        priority: newFilter.priority,
        status: newFilter.status,
        isResolved: newFilter.isResolved,
        dateFrom: newFilter.dateFrom,
        dateTo: newFilter.dateTo,
        sortBy: newFilter.sortBy,
        sortOrder: newFilter.sortOrder,
        cursor: newFilter.cursor,
        limit: newFilter.limit,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load more issue reports', failure);
        state = IssueReportsState.error(
          failure: failure,
          issueReportsFilter: newFilter,
          currentIssueReports: state.issueReports,
        );
      },
      (success) {
        this.logData('More issue reports loaded: ${success.data?.length ?? 0}');
        state = IssueReportsState.success(
          issueReports: [
            ...state.issueReports,
            ...(success.data ?? []).cast<IssueReport>(),
          ],
          issueReportsFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> createIssueReport(CreateIssueReportUsecaseParams params) async {
    this.logPresentation('Creating issue report');

    state = IssueReportsState.creating(
      currentIssueReports: state.issueReports,
      issueReportsFilter: state.issueReportsFilter,
      cursor: state.cursor,
    );

    final result = await _createIssueReportUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create issue report', failure);
        state = IssueReportsState.mutationError(
          currentIssueReports: state.issueReports,
          issueReportsFilter: state.issueReportsFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Issue report created successfully');

        // * Reset cursor when creating to fetch from beginning
        final resetCursorFilter = state.issueReportsFilter.copyWith(
          cursor: () => null,
        );

        state = state.copyWith(isLoading: true);
        state = await _loadIssueReports(issueReportsFilter: resetCursorFilter);

        state = IssueReportsState.mutationSuccess(
          issueReports: state.issueReports,
          issueReportsFilter: state.issueReportsFilter,
          mutationType: MutationType.create,
          message: success.message ?? 'Issue report created',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> updateIssueReport(UpdateIssueReportUsecaseParams params) async {
    this.logPresentation('Updating issue report: ${params.id}');

    state = IssueReportsState.updating(
      currentIssueReports: state.issueReports,
      issueReportsFilter: state.issueReportsFilter,
      cursor: state.cursor,
    );

    final result = await _updateIssueReportUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update issue report', failure);
        state = IssueReportsState.mutationError(
          currentIssueReports: state.issueReports,
          issueReportsFilter: state.issueReportsFilter,
          mutationType: MutationType.update,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Issue report updated successfully');

        // * Reset cursor when updating to fetch from beginning
        final resetCursorFilter = state.issueReportsFilter.copyWith(
          cursor: () => null,
        );

        state = state.copyWith(isLoading: true);
        state = await _loadIssueReports(issueReportsFilter: resetCursorFilter);

        state = IssueReportsState.mutationSuccess(
          issueReports: state.issueReports,
          issueReportsFilter: state.issueReportsFilter,
          mutationType: MutationType.update,
          message: success.message ?? 'Issue report updated',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> deleteIssueReport(DeleteIssueReportUsecaseParams params) async {
    this.logPresentation('Deleting issue report: ${params.id}');

    state = IssueReportsState.deleting(
      currentIssueReports: state.issueReports,
      issueReportsFilter: state.issueReportsFilter,
      cursor: state.cursor,
    );

    final result = await _deleteIssueReportUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete issue report', failure);
        state = IssueReportsState.mutationError(
          currentIssueReports: state.issueReports,
          issueReportsFilter: state.issueReportsFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Issue report deleted successfully');

        // * Reset cursor when deleting to fetch from beginning
        final resetCursorFilter = state.issueReportsFilter.copyWith(
          cursor: () => null,
        );

        state = state.copyWith(isLoading: true);
        state = await _loadIssueReports(issueReportsFilter: resetCursorFilter);

        state = IssueReportsState.mutationSuccess(
          issueReports: state.issueReports,
          issueReportsFilter: state.issueReportsFilter,
          mutationType: MutationType.delete,
          message: success.message ?? 'Issue report deleted',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> createManyIssueReports(
    BulkCreateIssueReportsParams params,
  ) async {
    this.logPresentation(
      'Creating ${params.issueReports.length} issue reports',
    );

    state = IssueReportsState.creating(
      currentIssueReports: state.issueReports,
      issueReportsFilter: state.issueReportsFilter,
      cursor: state.cursor,
    );

    final result = await _bulkCreateIssueReportsUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create issue reports', failure);
        state = IssueReportsState.mutationError(
          currentIssueReports: state.issueReports,
          issueReportsFilter: state.issueReportsFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData(
          'Issue reports created successfully: ${success.data?.issueReports.length ?? 0}',
        );

        // * Reset cursor when creating to fetch from beginning
        final resetCursorFilter = state.issueReportsFilter.copyWith(
          cursor: () => null,
        );

        // * Reload issue reports dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadIssueReports(
          issueReportsFilter: resetCursorFilter,
        );

        // * Set mutation success setelah reload
        state = IssueReportsState.mutationSuccess(
          issueReports: newState.issueReports,
          issueReportsFilter: newState.issueReportsFilter,
          mutationType: MutationType.create,
          message: 'Issue reports created successfully',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> deleteManyIssueReports(List<String> issueReportIds) async {
    this.logPresentation('Deleting ${issueReportIds.length} issue reports');

    state = IssueReportsState.deleting(
      currentIssueReports: state.issueReports,
      issueReportsFilter: state.issueReportsFilter,
      cursor: state.cursor,
    );

    final params = BulkDeleteParams(ids: issueReportIds);
    final result = await _bulkDeleteIssueReportsUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete issue reports', failure);
        state = IssueReportsState.mutationError(
          currentIssueReports: state.issueReports,
          issueReportsFilter: state.issueReportsFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Issue reports deleted successfully');

        // * Reset cursor when deleting to fetch from beginning
        final resetCursorFilter = state.issueReportsFilter.copyWith(
          cursor: () => null,
        );

        // * Reload issue reports dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadIssueReports(
          issueReportsFilter: resetCursorFilter,
        );

        // * Set mutation success setelah reload
        state = IssueReportsState.mutationSuccess(
          issueReports: newState.issueReports,
          issueReportsFilter: newState.issueReportsFilter,
          mutationType: MutationType.delete,
          message: 'Issue reports deleted successfully',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.issueReportsFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadIssueReports(issueReportsFilter: currentFilter);
  }
}
