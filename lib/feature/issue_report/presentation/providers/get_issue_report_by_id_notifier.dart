import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_report_by_id_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_detail_state.dart';

class GetIssueReportByIdNotifier
    extends AutoDisposeFamilyNotifier<IssueReportDetailState, String> {
  GetIssueReportByIdUsecase get _getIssueReportByIdUsecase =>
      ref.watch(getIssueReportByIdUsecaseProvider);

  @override
  IssueReportDetailState build(String id) {
    // * Cache issue report detail for 3 minutes (detail view use case)
    ref.cacheFor(const Duration(minutes: 3));
    this.logPresentation('Loading issue report by id: $id');
    _loadIssueReport(id);
    return IssueReportDetailState.initial();
  }

  Future<void> _loadIssueReport(String id) async {
    state = IssueReportDetailState.loading();

    final result = await _getIssueReportByIdUsecase.call(
      GetIssueReportByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load issue report by id', failure);
        state = IssueReportDetailState.error(failure);
      },
      (success) {
        this.logData('Issue report loaded by id: ${success.data?.id}');
        if (success.data != null) {
          state = IssueReportDetailState.success(success.data!);
        } else {
          state = IssueReportDetailState.error(
            const ServerFailure(message: 'Issue report not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadIssueReport(arg);
  }
}
