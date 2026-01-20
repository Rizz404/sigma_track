import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';
import 'package:sigma_track/feature/user/domain/entities/user_statistics.dart';
import 'package:sigma_track/feature/user/data/models/user_statistics_model.dart';

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
