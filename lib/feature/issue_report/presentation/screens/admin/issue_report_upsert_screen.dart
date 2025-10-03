import 'package:flutter/material.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class IssueReportUpsertScreen extends StatelessWidget {
  final IssueReport? issueReport;
  final String? issueReportId;

  const IssueReportUpsertScreen({
    super.key,
    this.issueReport,
    this.issueReportId,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('IssueReportUpsertScreen')),
      ),
    );
  }
}
