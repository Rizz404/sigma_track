import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_report_by_id_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_detail_state.dart';

class GetIssueReportByIdNotifier
    extends AutoDisposeNotifier<IssueReportDetailState> {
  GetIssueReportByIdUsecase get _getIssueReportByIdUsecase =>
      ref.watch(getIssueReportByIdUsecaseProvider);

  @override
  IssueReportDetailState build() {
    this.logPresentation('Initializing GetIssueReportByIdNotifier');
    return IssueReportDetailState.initial();
  }

  Future<void> getIssueReportById(String id) async {
    this.logPresentation('Getting issue report by id: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _getIssueReportByIdUsecase.call(
      GetIssueReportByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to get issue report by id',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully got issue report by id');
        state = state.copyWith(
          isLoading: false,
          issueReport: success.data,
          failure: null,
        );
      },
    );
  }
}
