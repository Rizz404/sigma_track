import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/issue_reports_notifier.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_reports_state.dart';

final issueReportsProvider =
    AutoDisposeNotifierProvider<IssueReportsNotifier, IssueReportsState>(
      IssueReportsNotifier.new,
    );

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final issueReportsSearchProvider =
    AutoDisposeNotifierProvider<IssueReportsNotifier, IssueReportsState>(
      IssueReportsNotifier.new,
    );
