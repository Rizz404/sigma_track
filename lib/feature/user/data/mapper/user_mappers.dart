import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';
import 'package:sigma_track/feature/user/domain/entities/user_statistics.dart';
import 'package:sigma_track/feature/user/data/models/user_statistics_model.dart';
import 'package:sigma_track/feature/user/domain/entities/user_personal_statistics.dart';
import 'package:sigma_track/feature/user/data/models/user_personal_statistics_model.dart';

extension UserModelMapper on UserModel {
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      fullName: fullName,
      role: role,
      employeeId: employeeId,
      preferredLang: Language.fromBackendCode(preferredLang),
      isActive: isActive,
      avatarUrl: avatarUrl,
      fcmToken: fcmToken,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension UserEntityMapper on User {
  UserModel toModel() {
    return UserModel(
      id: id,
      name: name,
      email: email,
      fullName: fullName,
      role: role,
      employeeId: employeeId,
      preferredLang: preferredLang.backendCode,
      isActive: isActive,
      avatarUrl: avatarUrl,
      fcmToken: fcmToken,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension UserStatisticsModelMapper on UserStatisticsModel {
  UserStatistics toEntity() {
    return UserStatistics(
      total: total.toEntity(),
      byStatus: byStatus.toEntity(),
      byRole: byRole.toEntity(),
      registrationTrends: registrationTrends
          .map((model) => model.toEntity())
          .toList(),
      summary: summary.toEntity(),
    );
  }
}

extension UserStatisticsEntityMapper on UserStatistics {
  UserStatisticsModel toModel() {
    return UserStatisticsModel(
      total: total.toModel(),
      byStatus: byStatus.toModel(),
      byRole: byRole.toModel(),
      registrationTrends: registrationTrends
          .map((entity) => entity.toModel())
          .toList(),
      summary: summary.toModel(),
    );
  }
}

extension UserCountStatisticsModelMapper on UserCountStatisticsModel {
  UserCountStatistics toEntity() => UserCountStatistics(count: count);
}

extension UserCountStatisticsEntityMapper on UserCountStatistics {
  UserCountStatisticsModel toModel() => UserCountStatisticsModel(count: count);
}

extension UserStatusStatisticsModelMapper on UserStatusStatisticsModel {
  UserStatusStatistics toEntity() =>
      UserStatusStatistics(active: active, inactive: inactive);
}

extension UserStatusStatisticsEntityMapper on UserStatusStatistics {
  UserStatusStatisticsModel toModel() =>
      UserStatusStatisticsModel(active: active, inactive: inactive);
}

extension UserRoleStatisticsModelMapper on UserRoleStatisticsModel {
  UserRoleStatistics toEntity() =>
      UserRoleStatistics(admin: admin, staff: staff, employee: employee);
}

extension UserRoleStatisticsEntityMapper on UserRoleStatistics {
  UserRoleStatisticsModel toModel() =>
      UserRoleStatisticsModel(admin: admin, staff: staff, employee: employee);
}

extension RegistrationTrendModelMapper on RegistrationTrendModel {
  RegistrationTrend toEntity() => RegistrationTrend(date: date, count: count);
}

extension RegistrationTrendEntityMapper on RegistrationTrend {
  RegistrationTrendModel toModel() =>
      RegistrationTrendModel(date: date, count: count);
}

extension UserSummaryStatisticsModelMapper on UserSummaryStatisticsModel {
  UserSummaryStatistics toEntity() => UserSummaryStatistics(
    totalUsers: totalUsers,
    activeUsersPercentage: activeUsersPercentage,
    inactiveUsersPercentage: inactiveUsersPercentage,
    adminPercentage: adminPercentage,
    staffPercentage: staffPercentage,
    employeePercentage: employeePercentage,
    averageUsersPerDay: averageUsersPerDay,
    latestRegistrationDate: latestRegistrationDate,
    earliestRegistrationDate: earliestRegistrationDate,
  );
}

extension UserSummaryStatisticsEntityMapper on UserSummaryStatistics {
  UserSummaryStatisticsModel toModel() => UserSummaryStatisticsModel(
    totalUsers: totalUsers,
    activeUsersPercentage: activeUsersPercentage,
    inactiveUsersPercentage: inactiveUsersPercentage,
    adminPercentage: adminPercentage,
    staffPercentage: staffPercentage,
    employeePercentage: employeePercentage,
    averageUsersPerDay: averageUsersPerDay,
    latestRegistrationDate: latestRegistrationDate,
    earliestRegistrationDate: earliestRegistrationDate,
  );
}

extension UserPersonalStatisticsModelMapper on UserPersonalStatisticsModel {
  UserPersonalStatistics toEntity() => UserPersonalStatistics(
    userId: userId,
    userName: userName,
    role: role,
    assets: (assets as UserPersonalAssetStatisticsModel).toEntity(),
    issueReports: (issueReports as UserPersonalIssueReportStatisticsModel)
        .toEntity(),
    summary: (summary as UserPersonalSummaryStatisticsModel).toEntity(),
  );
}

extension UserPersonalAssetStatisticsModelMapper
    on UserPersonalAssetStatisticsModel {
  UserPersonalAssetStatistics toEntity() => UserPersonalAssetStatistics(
    total: (total as UserPersonalAssetTotalStatisticsModel).toEntity(),
    byCondition: (byCondition as UserPersonalAssetConditionStatisticsModel)
        .toEntity(),
    items: items
        .map((e) => (e as UserPersonalAssetItemModel).toEntity())
        .toList(),
  );
}

extension UserPersonalAssetTotalStatisticsModelMapper
    on UserPersonalAssetTotalStatisticsModel {
  UserPersonalAssetTotalStatistics toEntity() =>
      UserPersonalAssetTotalStatistics(count: count, totalValue: totalValue);
}

extension UserPersonalAssetConditionStatisticsModelMapper
    on UserPersonalAssetConditionStatisticsModel {
  UserPersonalAssetConditionStatistics toEntity() =>
      UserPersonalAssetConditionStatistics(
        good: good,
        fair: fair,
        poor: poor,
        damaged: damaged,
      );
}

extension UserPersonalAssetItemModelMapper on UserPersonalAssetItemModel {
  UserPersonalAssetItem toEntity() => UserPersonalAssetItem(
    assetId: assetId,
    assetTag: assetTag,
    name: name,
    category: category,
    condition: condition,
    value: value,
    assignedDate: assignedDate,
  );
}

extension UserPersonalIssueReportStatisticsModelMapper
    on UserPersonalIssueReportStatisticsModel {
  UserPersonalIssueReportStatistics toEntity() =>
      UserPersonalIssueReportStatistics(
        total: (total as UserPersonalIssueReportTotalStatisticsModel)
            .toEntity(),
        byStatus: (byStatus as UserPersonalIssueReportStatusStatisticsModel)
            .toEntity(),
        byPriority:
            (byPriority as UserPersonalIssueReportPriorityStatisticsModel)
                .toEntity(),
        recentIssues: recentIssues
            .map((e) => (e as UserPersonalIssueReportItemModel).toEntity())
            .toList(),
        summary: (summary as UserPersonalIssueReportSummaryStatisticsModel)
            .toEntity(),
      );
}

extension UserPersonalIssueReportTotalStatisticsModelMapper
    on UserPersonalIssueReportTotalStatisticsModel {
  UserPersonalIssueReportTotalStatistics toEntity() =>
      UserPersonalIssueReportTotalStatistics(count: count);
}

extension UserPersonalIssueReportStatusStatisticsModelMapper
    on UserPersonalIssueReportStatusStatisticsModel {
  UserPersonalIssueReportStatusStatistics toEntity() =>
      UserPersonalIssueReportStatusStatistics(
        open: open,
        inProgress: inProgress,
        resolved: resolved,
        closed: closed,
      );
}

extension UserPersonalIssueReportPriorityStatisticsModelMapper
    on UserPersonalIssueReportPriorityStatisticsModel {
  UserPersonalIssueReportPriorityStatistics toEntity() =>
      UserPersonalIssueReportPriorityStatistics(
        high: high,
        medium: medium,
        low: low,
      );
}

extension UserPersonalIssueReportItemModelMapper
    on UserPersonalIssueReportItemModel {
  UserPersonalIssueReportItem toEntity() => UserPersonalIssueReportItem(
    issueId: issueId,
    assetId: assetId,
    assetTag: assetTag,
    title: title,
    priority: priority,
    status: status,
    reportedDate: reportedDate,
  );
}

extension UserPersonalIssueReportSummaryStatisticsModelMapper
    on UserPersonalIssueReportSummaryStatisticsModel {
  UserPersonalIssueReportSummaryStatistics toEntity() =>
      UserPersonalIssueReportSummaryStatistics(
        openIssuesCount: openIssuesCount,
        resolvedIssuesCount: resolvedIssuesCount,
        averageResolutionDays: averageResolutionDays,
      );
}

extension UserPersonalSummaryStatisticsModelMapper
    on UserPersonalSummaryStatisticsModel {
  UserPersonalSummaryStatistics toEntity() => UserPersonalSummaryStatistics(
    accountCreatedDate: accountCreatedDate,
    accountAge: accountAge,
    lastLogin: lastLogin,
    hasActiveIssues: hasActiveIssues,
    healthScore: healthScore,
  );
}
