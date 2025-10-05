import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';

enum IssueReportStatus { initial, loading, error, success }

class IssueReportMutationState extends Equatable {
  final IssueReportStatus issueReportStatus;
  final IssueReport? issueReport;
  final String? message;
  final Failure? failure;

  const IssueReportMutationState({
    required this.issueReportStatus,
    this.issueReport,
    this.message,
    this.failure,
  });

  factory IssueReportMutationState.success({
    IssueReport? issueReport,
    String? message,
  }) {
    return IssueReportMutationState(
      issueReportStatus: IssueReportStatus.success,
      issueReport: issueReport,
      message: message,
    );
  }

  factory IssueReportMutationState.error({Failure? failure}) {
    return IssueReportMutationState(
      issueReportStatus: IssueReportStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }

  IssueReportMutationState copyWith({
    IssueReportStatus? issueReportStatus,
    ValueGetter<IssueReport?>? issueReport,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return IssueReportMutationState(
      issueReportStatus: issueReportStatus ?? this.issueReportStatus,
      issueReport: issueReport != null ? issueReport() : this.issueReport,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [issueReportStatus, issueReport, message, failure];
}
