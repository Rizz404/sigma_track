import 'package:equatable/equatable.dart';

class IssueReportStatistics extends Equatable {
  final IssueReportCountStatistics total;
  final IssueReportPriorityStatistics byPriority;
  final IssueReportStatusStatistics byStatus;
  final IssueReportTypeStatistics byType;
  final List<IssueReportCreationTrend> creationTrends;
  final IssueReportSummaryStatistics summary;

  const IssueReportStatistics({
    required this.total,
    required this.byPriority,
    required this.byStatus,
    required this.byType,
    required this.creationTrends,
    required this.summary,
  });

  @override
  List<Object> get props => [
    total,
    byPriority,
    byStatus,
    byType,
    creationTrends,
    summary,
  ];
}

class IssueReportCountStatistics extends Equatable {
  final int count;

  const IssueReportCountStatistics({required this.count});

  @override
  List<Object> get props => [count];
}

class IssueReportPriorityStatistics extends Equatable {
  final int low;
  final int medium;
  final int high;
  final int critical;

  const IssueReportPriorityStatistics({
    required this.low,
    required this.medium,
    required this.high,
    required this.critical,
  });

  @override
  List<Object> get props => [low, medium, high, critical];
}

class IssueReportStatusStatistics extends Equatable {
  final int open;
  final int inProgress;
  final int resolved;
  final int closed;

  const IssueReportStatusStatistics({
    required this.open,
    required this.inProgress,
    required this.resolved,
    required this.closed,
  });

  @override
  List<Object> get props => [open, inProgress, resolved, closed];
}

class IssueReportTypeStatistics extends Equatable {
  final Map<String, int> types;

  const IssueReportTypeStatistics({required this.types});

  @override
  List<Object> get props => [types];
}

class IssueReportCreationTrend extends Equatable {
  final DateTime date;
  final int count;

  const IssueReportCreationTrend({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];
}

class IssueReportSummaryStatistics extends Equatable {
  final int totalReports;
  final double openPercentage;
  final double resolvedPercentage;
  final double averageResolutionTime;
  final String mostCommonPriority;
  final String mostCommonType;
  final int criticalUnresolvedCount;
  final double averageReportsPerDay;
  final DateTime latestCreationDate;
  final DateTime earliestCreationDate;

  const IssueReportSummaryStatistics({
    required this.totalReports,
    required this.openPercentage,
    required this.resolvedPercentage,
    required this.averageResolutionTime,
    required this.mostCommonPriority,
    required this.mostCommonType,
    required this.criticalUnresolvedCount,
    required this.averageReportsPerDay,
    required this.latestCreationDate,
    required this.earliestCreationDate,
  });

  @override
  List<Object> get props => [
    totalReports,
    openPercentage,
    resolvedPercentage,
    averageResolutionTime,
    mostCommonPriority,
    mostCommonType,
    criticalUnresolvedCount,
    averageReportsPerDay,
    latestCreationDate,
    earliestCreationDate,
  ];
}
