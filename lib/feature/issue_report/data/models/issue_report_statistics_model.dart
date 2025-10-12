import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class IssueReportStatisticsModel extends Equatable {
  final IssueReportCountStatisticsModel total;
  final IssueReportPriorityStatisticsModel byPriority;
  final IssueReportStatusStatisticsModel byStatus;
  final IssueReportTypeStatisticsModel byType;
  final List<IssueReportCreationTrendModel> creationTrends;
  final IssueReportSummaryStatisticsModel summary;

  const IssueReportStatisticsModel({
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

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byPriority': byPriority.toMap(),
      'byStatus': byStatus.toMap(),
      'byType': byType.toMap(),
      'creationTrends': creationTrends.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory IssueReportStatisticsModel.fromMap(Map<String, dynamic> map) {
    return IssueReportStatisticsModel(
      total: IssueReportCountStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('total'),
      ),
      byPriority: IssueReportPriorityStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byPriority'),
      ),
      byStatus: IssueReportStatusStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byStatus'),
      ),
      byType: IssueReportTypeStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byType'),
      ),
      creationTrends: List<IssueReportCreationTrendModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('creationTrends')
                ?.map((x) => IssueReportCreationTrendModel.fromMap(x)) ??
            [],
      ),
      summary: IssueReportSummaryStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('summary'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueReportStatisticsModel.fromJson(String source) =>
      IssueReportStatisticsModel.fromMap(json.decode(source));
}

class IssueReportCountStatisticsModel extends Equatable {
  final int count;

  const IssueReportCountStatisticsModel({required this.count});

  @override
  List<Object> get props => [count];

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory IssueReportCountStatisticsModel.fromMap(Map<String, dynamic> map) {
    return IssueReportCountStatisticsModel(
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueReportCountStatisticsModel.fromJson(String source) =>
      IssueReportCountStatisticsModel.fromMap(json.decode(source));
}

class IssueReportPriorityStatisticsModel extends Equatable {
  final int low;
  final int medium;
  final int high;
  final int critical;

  const IssueReportPriorityStatisticsModel({
    required this.low,
    required this.medium,
    required this.high,
    required this.critical,
  });

  @override
  List<Object> get props => [low, medium, high, critical];

  Map<String, dynamic> toMap() {
    return {'low': low, 'medium': medium, 'high': high, 'critical': critical};
  }

  factory IssueReportPriorityStatisticsModel.fromMap(Map<String, dynamic> map) {
    return IssueReportPriorityStatisticsModel(
      low: map.getFieldOrNull<int>('low') ?? 0,
      medium: map.getFieldOrNull<int>('medium') ?? 0,
      high: map.getFieldOrNull<int>('high') ?? 0,
      critical: map.getFieldOrNull<int>('critical') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueReportPriorityStatisticsModel.fromJson(String source) =>
      IssueReportPriorityStatisticsModel.fromMap(json.decode(source));
}

class IssueReportStatusStatisticsModel extends Equatable {
  final int open;
  final int inProgress;
  final int resolved;
  final int closed;

  const IssueReportStatusStatisticsModel({
    required this.open,
    required this.inProgress,
    required this.resolved,
    required this.closed,
  });

  @override
  List<Object> get props => [open, inProgress, resolved, closed];

  Map<String, dynamic> toMap() {
    return {
      'open': open,
      'inProgress': inProgress,
      'resolved': resolved,
      'closed': closed,
    };
  }

  factory IssueReportStatusStatisticsModel.fromMap(Map<String, dynamic> map) {
    return IssueReportStatusStatisticsModel(
      open: map.getFieldOrNull<int>('open') ?? 0,
      inProgress: map.getFieldOrNull<int>('inProgress') ?? 0,
      resolved: map.getFieldOrNull<int>('resolved') ?? 0,
      closed: map.getFieldOrNull<int>('closed') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueReportStatusStatisticsModel.fromJson(String source) =>
      IssueReportStatusStatisticsModel.fromMap(json.decode(source));
}

class IssueReportTypeStatisticsModel extends Equatable {
  final Map<String, int> types;

  const IssueReportTypeStatisticsModel({required this.types});

  @override
  List<Object> get props => [types];

  Map<String, dynamic> toMap() {
    return {'types': types};
  }

  factory IssueReportTypeStatisticsModel.fromMap(Map<String, dynamic> map) {
    return IssueReportTypeStatisticsModel(
      types: Map<String, int>.from(
        map.getFieldOrNull<Map<String, dynamic>>('types') ?? {},
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueReportTypeStatisticsModel.fromJson(String source) =>
      IssueReportTypeStatisticsModel.fromMap(json.decode(source));
}

class IssueReportCreationTrendModel extends Equatable {
  final DateTime date;
  final int count;

  const IssueReportCreationTrendModel({
    required this.date,
    required this.count,
  });

  @override
  List<Object> get props => [date, count];

  Map<String, dynamic> toMap() {
    return {'date': date.millisecondsSinceEpoch, 'count': count};
  }

  factory IssueReportCreationTrendModel.fromMap(Map<String, dynamic> map) {
    return IssueReportCreationTrendModel(
      date: map.getDateTime('date'),
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueReportCreationTrendModel.fromJson(String source) =>
      IssueReportCreationTrendModel.fromMap(json.decode(source));
}

class IssueReportSummaryStatisticsModel extends Equatable {
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

  const IssueReportSummaryStatisticsModel({
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

  Map<String, dynamic> toMap() {
    return {
      'totalReports': totalReports,
      'openPercentage': openPercentage,
      'resolvedPercentage': resolvedPercentage,
      'averageResolutionTimeInDays': averageResolutionTime,
      'mostCommonPriority': mostCommonPriority,
      'mostCommonType': mostCommonType,
      'criticalUnresolvedCount': criticalUnresolvedCount,
      'averageReportsPerDay': averageReportsPerDay,
      'latestCreationDate': latestCreationDate.millisecondsSinceEpoch,
      'earliestCreationDate': earliestCreationDate.millisecondsSinceEpoch,
    };
  }

  factory IssueReportSummaryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return IssueReportSummaryStatisticsModel(
      totalReports: map.getFieldOrNull<int>('totalReports') ?? 0,
      openPercentage: map.getDoubleOrNull('openPercentage') ?? 0.0,
      resolvedPercentage: map.getDoubleOrNull('resolvedPercentage') ?? 0.0,
      averageResolutionTime:
          map.getDoubleOrNull('averageResolutionTimeInDays') ?? 0.0,
      mostCommonPriority:
          map.getFieldOrNull<String>('mostCommonPriority') ?? '',
      mostCommonType: map.getFieldOrNull<String>('mostCommonType') ?? '',
      criticalUnresolvedCount:
          map.getFieldOrNull<int>('criticalUnresolvedCount') ?? 0,
      averageReportsPerDay: map.getDoubleOrNull('averageReportsPerDay') ?? 0.0,
      latestCreationDate: map.getDateTime('latestCreationDate'),
      earliestCreationDate: map.getDateTime('earliestCreationDate'),
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueReportSummaryStatisticsModel.fromJson(String source) =>
      IssueReportSummaryStatisticsModel.fromMap(json.decode(source));
}
