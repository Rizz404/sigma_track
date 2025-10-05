import 'package:flutter/material.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class IssueReportDetailScreen extends StatelessWidget {
  final IssueReport? issueReport;
  final String? id;

  const IssueReportDetailScreen({super.key, this.issueReport, this.id});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('IssueReportDetailScreen')),
      ),
    );
  }
}
