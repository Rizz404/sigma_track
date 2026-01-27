import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class UserPersonalStatistics extends Equatable {
  final String userId;
  final String userName;
  final UserRole role;
  final UserPersonalAssetStatistics assets;
  final UserPersonalIssueReportStatistics issueReports;
  final UserPersonalSummaryStatistics summary;

  const UserPersonalStatistics({
    required this.userId,
    required this.userName,
    required this.role,
    required this.assets,
    required this.issueReports,
    required this.summary,
  });

  @override
  List<Object?> get props => [
    userId,
    userName,
    role,
    assets,
    issueReports,
    summary,
  ];
}

class UserPersonalAssetStatistics extends Equatable {
  final UserPersonalAssetTotalStatistics total;
  final UserPersonalAssetConditionStatistics byCondition;
  final List<UserPersonalAssetItem> items;

  const UserPersonalAssetStatistics({
    required this.total,
    required this.byCondition,
    required this.items,
  });

  @override
  List<Object?> get props => [total, byCondition, items];
}

class UserPersonalAssetTotalStatistics extends Equatable {
  final int count;
  final double totalValue;

  const UserPersonalAssetTotalStatistics({
    required this.count,
    required this.totalValue,
  });

  @override
  List<Object?> get props => [count, totalValue];
}

class UserPersonalAssetConditionStatistics extends Equatable {
  final int good;
  final int fair;
  final int poor;
  final int damaged;

  const UserPersonalAssetConditionStatistics({
    required this.good,
    required this.fair,
    required this.poor,
    required this.damaged,
  });

  @override
  List<Object?> get props => [good, fair, poor, damaged];
}

class UserPersonalAssetItem extends Equatable {
  final String assetId;
  final String assetTag;
  final String name;
  final String category;
  final String condition;
  final double value;
  final DateTime assignedDate;

  const UserPersonalAssetItem({
    required this.assetId,
    required this.assetTag,
    required this.name,
    required this.category,
    required this.condition,
    required this.value,
    required this.assignedDate,
  });

  @override
  List<Object?> get props => [
    assetId,
    assetTag,
    name,
    category,
    condition,
    value,
    assignedDate,
  ];
}

class UserPersonalIssueReportStatistics extends Equatable {
  final UserPersonalIssueReportTotalStatistics total;
  final UserPersonalIssueReportStatusStatistics byStatus;
  final UserPersonalIssueReportPriorityStatistics byPriority;
  final List<UserPersonalIssueReportItem> recentIssues;
  final UserPersonalIssueReportSummaryStatistics summary;

  const UserPersonalIssueReportStatistics({
    required this.total,
    required this.byStatus,
    required this.byPriority,
    required this.recentIssues,
    required this.summary,
  });

  @override
  List<Object?> get props => [
    total,
    byStatus,
    byPriority,
    recentIssues,
    summary,
  ];
}

class UserPersonalIssueReportTotalStatistics extends Equatable {
  final int count;

  const UserPersonalIssueReportTotalStatistics({required this.count});

  @override
  List<Object?> get props => [count];
}

class UserPersonalIssueReportStatusStatistics extends Equatable {
  final int open;
  final int inProgress;
  final int resolved;
  final int closed;

  const UserPersonalIssueReportStatusStatistics({
    required this.open,
    required this.inProgress,
    required this.resolved,
    required this.closed,
  });

  @override
  List<Object?> get props => [open, inProgress, resolved, closed];
}

class UserPersonalIssueReportPriorityStatistics extends Equatable {
  final int high;
  final int medium;
  final int low;

  const UserPersonalIssueReportPriorityStatistics({
    required this.high,
    required this.medium,
    required this.low,
  });

  @override
  List<Object?> get props => [high, medium, low];
}

class UserPersonalIssueReportItem extends Equatable {
  final String issueId;
  final String? assetId;
  final String? assetTag;
  final String title;
  final String priority;
  final String status;
  final DateTime reportedDate;

  const UserPersonalIssueReportItem({
    required this.issueId,
    this.assetId,
    this.assetTag,
    required this.title,
    required this.priority,
    required this.status,
    required this.reportedDate,
  });

  @override
  List<Object?> get props => [
    issueId,
    assetId,
    assetTag,
    title,
    priority,
    status,
    reportedDate,
  ];
}

class UserPersonalIssueReportSummaryStatistics extends Equatable {
  final int openIssuesCount;
  final int resolvedIssuesCount;
  final double averageResolutionDays;

  const UserPersonalIssueReportSummaryStatistics({
    required this.openIssuesCount,
    required this.resolvedIssuesCount,
    required this.averageResolutionDays,
  });

  @override
  List<Object?> get props => [
    openIssuesCount,
    resolvedIssuesCount,
    averageResolutionDays,
  ];
}

class UserPersonalSummaryStatistics extends Equatable {
  final DateTime accountCreatedDate;
  final String accountAge;
  final DateTime? lastLogin;
  final bool hasActiveIssues;
  final int healthScore;

  const UserPersonalSummaryStatistics({
    required this.accountCreatedDate,
    required this.accountAge,
    this.lastLogin,
    required this.hasActiveIssues,
    required this.healthScore,
  });

  @override
  List<Object?> get props => [
    accountCreatedDate,
    accountAge,
    lastLogin,
    hasActiveIssues,
    healthScore,
  ];
}
