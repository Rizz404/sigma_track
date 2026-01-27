import 'dart:convert';

import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/feature/user/domain/entities/user_personal_statistics.dart';

class UserPersonalStatisticsModel extends UserPersonalStatistics {
  const UserPersonalStatisticsModel({
    required super.userId,
    required super.userName,
    required super.role,
    required super.assets,
    required super.issueReports,
    required super.summary,
  });

  factory UserPersonalStatisticsModel.fromMap(Map<String, dynamic> map) {
    return UserPersonalStatisticsModel(
      userId: map.getField<String>('userId'),
      userName: map.getField<String>('userName'),
      role: UserRole.values.firstWhere(
        (e) => e.name == map.getFieldOrNull<String>('role'),
        orElse: () => UserRole.employee,
      ),
      assets: UserPersonalAssetStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('assets'),
      ),
      issueReports: UserPersonalIssueReportStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('issueReports'),
      ),
      summary: UserPersonalSummaryStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('summary'),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'role': role.name,
      'assets': (assets as UserPersonalAssetStatisticsModel).toMap(),
      'issueReports': (issueReports as UserPersonalIssueReportStatisticsModel)
          .toMap(),
      'summary': (summary as UserPersonalSummaryStatisticsModel).toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory UserPersonalStatisticsModel.fromJson(String source) =>
      UserPersonalStatisticsModel.fromMap(json.decode(source));
}

class UserPersonalAssetStatisticsModel extends UserPersonalAssetStatistics {
  const UserPersonalAssetStatisticsModel({
    required super.total,
    required super.byCondition,
    required super.items,
  });

  factory UserPersonalAssetStatisticsModel.fromMap(Map<String, dynamic> map) {
    return UserPersonalAssetStatisticsModel(
      total: UserPersonalAssetTotalStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('total'),
      ),
      byCondition: UserPersonalAssetConditionStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byCondition'),
      ),
      items: List<UserPersonalAssetItemModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('items')
                ?.map(
                  (x) => UserPersonalAssetItemModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': (total as UserPersonalAssetTotalStatisticsModel).toMap(),
      'byCondition': (byCondition as UserPersonalAssetConditionStatisticsModel)
          .toMap(),
      'items': items
          .map((x) => (x as UserPersonalAssetItemModel).toMap())
          .toList(),
    };
  }
}

class UserPersonalAssetTotalStatisticsModel
    extends UserPersonalAssetTotalStatistics {
  const UserPersonalAssetTotalStatisticsModel({
    required super.count,
    required super.totalValue,
  });

  factory UserPersonalAssetTotalStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserPersonalAssetTotalStatisticsModel(
      count: map.getFieldOrNull<int>('count') ?? 0,
      totalValue: map.getFieldOrNull<double>('totalValue') ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'count': count, 'totalValue': totalValue};
  }
}

class UserPersonalAssetConditionStatisticsModel
    extends UserPersonalAssetConditionStatistics {
  const UserPersonalAssetConditionStatisticsModel({
    required super.good,
    required super.fair,
    required super.poor,
    required super.damaged,
  });

  factory UserPersonalAssetConditionStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserPersonalAssetConditionStatisticsModel(
      good: map.getFieldOrNull<int>('good') ?? 0,
      fair: map.getFieldOrNull<int>('fair') ?? 0,
      poor: map.getFieldOrNull<int>('poor') ?? 0,
      damaged: map.getFieldOrNull<int>('damaged') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'good': good, 'fair': fair, 'poor': poor, 'damaged': damaged};
  }
}

class UserPersonalAssetItemModel extends UserPersonalAssetItem {
  const UserPersonalAssetItemModel({
    required super.assetId,
    required super.assetTag,
    required super.name,
    required super.category,
    required super.condition,
    required super.value,
    required super.assignedDate,
  });

  factory UserPersonalAssetItemModel.fromMap(Map<String, dynamic> map) {
    return UserPersonalAssetItemModel(
      assetId: map.getField<String>('assetId'),
      assetTag: map.getField<String>('assetTag'),
      name: map.getField<String>('name'),
      category: map.getField<String>('category'),
      condition: map.getField<String>('condition'),
      value: map.getFieldOrNull<double>('value') ?? 0.0,
      assignedDate: map.getFieldOrNull<DateTime>('assignedDate') ?? DateTime(0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'assetTag': assetTag,
      'name': name,
      'category': category,
      'condition': condition,
      'value': value,
      'assignedDate': assignedDate.toIso8601String(),
    };
  }
}

class UserPersonalIssueReportStatisticsModel
    extends UserPersonalIssueReportStatistics {
  const UserPersonalIssueReportStatisticsModel({
    required super.total,
    required super.byStatus,
    required super.byPriority,
    required super.recentIssues,
    required super.summary,
  });

  factory UserPersonalIssueReportStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserPersonalIssueReportStatisticsModel(
      total: UserPersonalIssueReportTotalStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('total'),
      ),
      byStatus: UserPersonalIssueReportStatusStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byStatus'),
      ),
      byPriority: UserPersonalIssueReportPriorityStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byPriority'),
      ),
      recentIssues: List<UserPersonalIssueReportItemModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('recentIssues')
                ?.map(
                  (x) => UserPersonalIssueReportItemModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
      summary: UserPersonalIssueReportSummaryStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('summary'),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': (total as UserPersonalIssueReportTotalStatisticsModel).toMap(),
      'byStatus': (byStatus as UserPersonalIssueReportStatusStatisticsModel)
          .toMap(),
      'byPriority':
          (byPriority as UserPersonalIssueReportPriorityStatisticsModel)
              .toMap(),
      'recentIssues': recentIssues
          .map((x) => (x as UserPersonalIssueReportItemModel).toMap())
          .toList(),
      'summary': (summary as UserPersonalIssueReportSummaryStatisticsModel)
          .toMap(),
    };
  }
}

class UserPersonalIssueReportTotalStatisticsModel
    extends UserPersonalIssueReportTotalStatistics {
  const UserPersonalIssueReportTotalStatisticsModel({required super.count});

  factory UserPersonalIssueReportTotalStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserPersonalIssueReportTotalStatisticsModel(
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'count': count};
  }
}

class UserPersonalIssueReportStatusStatisticsModel
    extends UserPersonalIssueReportStatusStatistics {
  const UserPersonalIssueReportStatusStatisticsModel({
    required super.open,
    required super.inProgress,
    required super.resolved,
    required super.closed,
  });

  factory UserPersonalIssueReportStatusStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserPersonalIssueReportStatusStatisticsModel(
      open: map.getFieldOrNull<int>('open') ?? 0,
      inProgress: map.getFieldOrNull<int>('inProgress') ?? 0,
      resolved: map.getFieldOrNull<int>('resolved') ?? 0,
      closed: map.getFieldOrNull<int>('closed') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'open': open,
      'inProgress': inProgress,
      'resolved': resolved,
      'closed': closed,
    };
  }
}

class UserPersonalIssueReportPriorityStatisticsModel
    extends UserPersonalIssueReportPriorityStatistics {
  const UserPersonalIssueReportPriorityStatisticsModel({
    required super.high,
    required super.medium,
    required super.low,
  });

  factory UserPersonalIssueReportPriorityStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserPersonalIssueReportPriorityStatisticsModel(
      high: map.getFieldOrNull<int>('high') ?? 0,
      medium: map.getFieldOrNull<int>('medium') ?? 0,
      low: map.getFieldOrNull<int>('low') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'high': high, 'medium': medium, 'low': low};
  }
}

class UserPersonalIssueReportItemModel extends UserPersonalIssueReportItem {
  const UserPersonalIssueReportItemModel({
    required super.issueId,
    super.assetId,
    super.assetTag,
    required super.title,
    required super.priority,
    required super.status,
    required super.reportedDate,
  });

  factory UserPersonalIssueReportItemModel.fromMap(Map<String, dynamic> map) {
    return UserPersonalIssueReportItemModel(
      issueId: map.getField<String>('issueId'),
      assetId: map.getFieldOrNull<String>('assetId'),
      assetTag: map.getFieldOrNull<String>('assetTag'),
      title: map.getField<String>('title'),
      priority: map.getField<String>('priority'),
      status: map.getField<String>('status'),
      reportedDate: map.getFieldOrNull<DateTime>('reportedDate') ?? DateTime(0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'issueId': issueId,
      'assetId': assetId,
      'assetTag': assetTag,
      'title': title,
      'priority': priority,
      'status': status,
      'reportedDate': reportedDate.toIso8601String(),
    };
  }
}

class UserPersonalIssueReportSummaryStatisticsModel
    extends UserPersonalIssueReportSummaryStatistics {
  const UserPersonalIssueReportSummaryStatisticsModel({
    required super.openIssuesCount,
    required super.resolvedIssuesCount,
    required super.averageResolutionDays,
  });

  factory UserPersonalIssueReportSummaryStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserPersonalIssueReportSummaryStatisticsModel(
      openIssuesCount: map.getFieldOrNull<int>('openIssuesCount') ?? 0,
      resolvedIssuesCount: map.getFieldOrNull<int>('resolvedIssuesCount') ?? 0,
      averageResolutionDays:
          map.getFieldOrNull<double>('averageResolutionDays') ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'openIssuesCount': openIssuesCount,
      'resolvedIssuesCount': resolvedIssuesCount,
      'averageResolutionDays': averageResolutionDays,
    };
  }
}

class UserPersonalSummaryStatisticsModel extends UserPersonalSummaryStatistics {
  const UserPersonalSummaryStatisticsModel({
    required super.accountCreatedDate,
    required super.accountAge,
    super.lastLogin,
    required super.hasActiveIssues,
    required super.healthScore,
  });

  factory UserPersonalSummaryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return UserPersonalSummaryStatisticsModel(
      accountCreatedDate:
          map.getFieldOrNull<DateTime>('accountCreatedDate') ?? DateTime(0),
      accountAge: map.getField<String>('accountAge'),
      lastLogin: map.getFieldOrNull<DateTime>('lastLogin'),
      hasActiveIssues: map.getFieldOrNull<bool>('hasActiveIssues') ?? false,
      healthScore: map.getFieldOrNull<int>('healthScore') ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountCreatedDate': accountCreatedDate.toIso8601String(),
      'accountAge': accountAge,
      'lastLogin': lastLogin?.toIso8601String(),
      'hasActiveIssues': hasActiveIssues,
      'healthScore': healthScore,
    };
  }
}
