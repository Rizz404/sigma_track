import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';

class IssueReportDetailState extends Equatable {
  final IssueReport? issueReport;
  final bool isLoading;
  final Failure? failure;

  const IssueReportDetailState({
    this.issueReport,
    this.isLoading = false,
    this.failure,
  });

  factory IssueReportDetailState.initial() => const IssueReportDetailState();

  IssueReportDetailState copyWith({
    IssueReport? issueReport,
    bool? isLoading,
    Failure? failure,
  }) {
    return IssueReportDetailState(
      issueReport: issueReport ?? this.issueReport,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [issueReport, isLoading, failure];
}
