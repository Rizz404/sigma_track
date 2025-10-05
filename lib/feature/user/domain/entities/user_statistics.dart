import 'package:equatable/equatable.dart';

class UserStatistics extends Equatable {
  final UserCountStatistics total;
  final UserStatusStatistics byStatus;
  final UserRoleStatistics byRole;
  final List<RegistrationTrend> registrationTrends;
  final UserSummaryStatistics summary;

  const UserStatistics({
    required this.total,
    required this.byStatus,
    required this.byRole,
    required this.registrationTrends,
    required this.summary,
  });

  factory UserStatistics.dummy() => UserStatistics(
    total: const UserCountStatistics(count: 0),
    byStatus: const UserStatusStatistics(active: 0, inactive: 0),
    byRole: const UserRoleStatistics(admin: 0, staff: 0, employee: 0),
    registrationTrends: const [],
    summary: UserSummaryStatistics(
      totalUsers: 0,
      activeUsersPercentage: 0.0,
      inactiveUsersPercentage: 0.0,
      adminPercentage: 0.0,
      staffPercentage: 0.0,
      employeePercentage: 0.0,
      averageUsersPerDay: 0.0,
      latestRegistrationDate: DateTime(0),
      earliestRegistrationDate: DateTime(0),
    ),
  );

  @override
  List<Object> get props {
    return [total, byStatus, byRole, registrationTrends, summary];
  }
}

class UserCountStatistics extends Equatable {
  final int count;

  const UserCountStatistics({required this.count});

  @override
  List<Object> get props => [count];
}

class UserStatusStatistics extends Equatable {
  final int active;
  final int inactive;

  const UserStatusStatistics({required this.active, required this.inactive});

  @override
  List<Object> get props => [active, inactive];
}

class UserRoleStatistics extends Equatable {
  final int admin;
  final int staff;
  final int employee;

  const UserRoleStatistics({
    required this.admin,
    required this.staff,
    required this.employee,
  });

  @override
  List<Object> get props => [admin, staff, employee];
}

class RegistrationTrend extends Equatable {
  final DateTime date;
  final int count;

  const RegistrationTrend({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];
}

class UserSummaryStatistics extends Equatable {
  final int totalUsers;
  final double activeUsersPercentage;
  final double inactiveUsersPercentage;
  final double adminPercentage;
  final double staffPercentage;
  final double employeePercentage;
  final double averageUsersPerDay;
  final DateTime latestRegistrationDate;
  final DateTime earliestRegistrationDate;

  const UserSummaryStatistics({
    required this.totalUsers,
    required this.activeUsersPercentage,
    required this.inactiveUsersPercentage,
    required this.adminPercentage,
    required this.staffPercentage,
    required this.employeePercentage,
    required this.averageUsersPerDay,
    required this.latestRegistrationDate,
    required this.earliestRegistrationDate,
  });

  @override
  List<Object> get props => [
    totalUsers,
    activeUsersPercentage,
    inactiveUsersPercentage,
    adminPercentage,
    staffPercentage,
    employeePercentage,
    averageUsersPerDay,
    latestRegistrationDate,
    earliestRegistrationDate,
  ];
}
