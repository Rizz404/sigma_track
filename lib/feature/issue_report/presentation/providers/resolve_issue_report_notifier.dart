import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/resolve_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_detail_state.dart';

class ResolveIssueReportNotifier
    extends AutoDisposeNotifier<IssueReportDetailState> {
  ResolveIssueReportUsecase get _resolveIssueReportUsecase =>
      ref.watch(resolveIssueReportUsecaseProvider);

  @override
  IssueReportDetailState build() {
    this.logPresentation('Initializing ResolveIssueReportNotifier');
    return IssueReportDetailState.initial();
  }

  Future<void> resolveIssueReport({
    required String id,
    required String resolvedById,
    String? resolutionNotes,
  }) async {
    this.logPresentation('Resolving issue report: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _resolveIssueReportUsecase.call(
      ResolveIssueReportUsecaseParams(
        id: id,
        resolvedById: resolvedById,
        resolutionNotes: resolutionNotes,
      ),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to resolve issue report',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully resolved issue report');
        state = state.copyWith(
          isLoading: false,
          issueReport: success.data,
          failure: null,
        );
      },
    );
  }
}
