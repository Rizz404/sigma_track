import 'package:flutter/material.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class IssueReportDetailScreen extends StatelessWidget {
  final IssueReport issueReport;

  const IssueReportDetailScreen({super.key, required this.issueReport});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('IssueReportDetailScreen')),
      ),
    );
  }
}
