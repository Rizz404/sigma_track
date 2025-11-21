import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/export_issue_report_list_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/export_issue_reports_state.dart';

class ExportIssueReportsNotifier
    extends AutoDisposeNotifier<ExportIssueReportsState> {
  ExportIssueReportListUsecase get _exportIssueReportListUsecase =>
      ref.watch(exportIssueReportListUsecaseProvider);

  @override
  ExportIssueReportsState build() {
    this.logPresentation('Initializing ExportIssueReportsNotifier');
    return ExportIssueReportsState.initial();
  }

  void reset() {
    this.logPresentation('Resetting export state');
    state = ExportIssueReportsState.initial();
  }

  Future<void> exportIssueReports(
    ExportIssueReportListUsecaseParams params,
  ) async {
    this.logPresentation('Exporting issue reports with params: $params');

    state = state.copyWith(
      isLoading: true,
      failure: null,
      message: null,
      previewData: null,
    );

    final result = await _exportIssueReportListUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to export issue reports', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) async {
        this.logData('Issue reports exported successfully');
        state = state.copyWith(
          isLoading: false,
          previewData: success.data,
          message: 'Export preview generated successfully',
        );
      },
    );
  }
}
