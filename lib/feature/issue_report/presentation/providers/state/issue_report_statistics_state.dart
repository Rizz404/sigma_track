import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report_statistics.dart';

// * State untuk getIssueReportsStatistics usecase
class IssueReportStatisticsState extends Equatable {
  final IssueReportStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const IssueReportStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory IssueReportStatisticsState.initial() =>
      const IssueReportStatisticsState(isLoading: true);

  factory IssueReportStatisticsState.loading() =>
      const IssueReportStatisticsState(isLoading: true);

  factory IssueReportStatisticsState.success(
    IssueReportStatistics statistics,
  ) => IssueReportStatisticsState(statistics: statistics);

  factory IssueReportStatisticsState.error(Failure failure) =>
      IssueReportStatisticsState(failure: failure);

  IssueReportStatisticsState copyWith({
    IssueReportStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return IssueReportStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
