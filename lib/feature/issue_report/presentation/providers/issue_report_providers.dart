import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/check_issue_report_exists_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/count_issue_reports_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/get_issue_report_by_id_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/get_issue_reports_statistics_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/issue_reports_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/issue_reports_search_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/reopen_issue_report_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/resolve_issue_report_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/my_issue_reports_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_boolean_state.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_count_state.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_detail_state.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_report_statistics_state.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_reports_state.dart';

final issueReportsProvider =
    AutoDisposeNotifierProvider<IssueReportsNotifier, IssueReportsState>(
      IssueReportsNotifier.new,
    );

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final issueReportsSearchProvider =
    AutoDisposeNotifierProvider<IssueReportsSearchNotifier, IssueReportsState>(
      IssueReportsSearchNotifier.new,
    );

final getIssueReportByIdProvider =
    AutoDisposeNotifierProviderFamily<
      GetIssueReportByIdNotifier,
      IssueReportDetailState,
      String
    >(GetIssueReportByIdNotifier.new);

final checkIssueReportExistsProvider =
    AutoDisposeNotifierProvider<
      CheckIssueReportExistsNotifier,
      IssueReportBooleanState
    >(CheckIssueReportExistsNotifier.new);

final countIssueReportsProvider =
    AutoDisposeNotifierProvider<
      CountIssueReportsNotifier,
      IssueReportCountState
    >(CountIssueReportsNotifier.new);

final getIssueReportsStatisticsProvider =
    AutoDisposeNotifierProvider<
      GetIssueReportsStatisticsNotifier,
      IssueReportStatisticsState
    >(GetIssueReportsStatisticsNotifier.new);

final resolveIssueReportProvider =
    AutoDisposeNotifierProvider<
      ResolveIssueReportNotifier,
      IssueReportDetailState
    >(ResolveIssueReportNotifier.new);

final reopenIssueReportProvider =
    AutoDisposeNotifierProvider<
      ReopenIssueReportNotifier,
      IssueReportDetailState
    >(ReopenIssueReportNotifier.new);

final myIssueReportsProvider =
    AutoDisposeNotifierProvider<MyIssueReportsNotifier, IssueReportsState>(
      MyIssueReportsNotifier.new,
    );
