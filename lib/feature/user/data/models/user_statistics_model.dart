import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class UserStatisticsModel extends Equatable {
  final UserCountStatisticsModel total;
  final UserStatusStatisticsModel byStatus;
  final UserRoleStatisticsModel byRole;
  final List<RegistrationTrendModel> registrationTrends;
  final UserSummaryStatisticsModel summary;

  const UserStatisticsModel({
    required this.total,
    required this.byStatus,
    required this.byRole,
    required this.registrationTrends,
    required this.summary,
  });

  @override
  List<Object> get props {
    return [total, byStatus, byRole, registrationTrends, summary];
  }

  UserStatisticsModel copyWith({
    UserCountStatisticsModel? total,
    UserStatusStatisticsModel? byStatus,
    UserRoleStatisticsModel? byRole,
    List<RegistrationTrendModel>? registrationTrends,
    UserSummaryStatisticsModel? summary,
  }) {
    return UserStatisticsModel(
      total: total ?? this.total,
      byStatus: byStatus ?? this.byStatus,
      byRole: byRole ?? this.byRole,
      registrationTrends: registrationTrends ?? this.registrationTrends,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byStatus': byStatus.toMap(),
      'byRole': byRole.toMap(),
      'registrationTrends': registrationTrends.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory UserStatisticsModel.fromMap(Map<String, dynamic> map) {
    return UserStatisticsModel(
      total: UserCountStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('total'),
      ),
      byStatus: UserStatusStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byStatus'),
      ),
      byRole: UserRoleStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byRole'),
      ),
      registrationTrends: List<RegistrationTrendModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('registrationTrends')
                ?.map(
                  (x) =>
                      RegistrationTrendModel.fromMap(x as Map<String, dynamic>),
                ) ??
            [],
      ),
      summary: UserSummaryStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('summary'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserStatisticsModel.fromJson(String source) =>
      UserStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserStatisticsModel(total: $total, byStatus: $byStatus, byRole: $byRole, registrationTrends: $registrationTrends, summary: $summary)';
  }
}

class UserCountStatisticsModel extends Equatable {
  final int count;

  const UserCountStatisticsModel({required this.count});

  @override
  List<Object> get props => [count];

  UserCountStatisticsModel copyWith({int? count}) {
    return UserCountStatisticsModel(count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory UserCountStatisticsModel.fromMap(Map<String, dynamic> map) {
    return UserCountStatisticsModel(
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCountStatisticsModel.fromJson(String source) =>
      UserCountStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserCountStatisticsModel(count: $count)';
}

class UserStatusStatisticsModel extends Equatable {
  final int active;
  final int inactive;

  const UserStatusStatisticsModel({
    required this.active,
    required this.inactive,
  });

  @override
  List<Object> get props => [active, inactive];

  UserStatusStatisticsModel copyWith({int? active, int? inactive}) {
    return UserStatusStatisticsModel(
      active: active ?? this.active,
      inactive: inactive ?? this.inactive,
    );
  }

  Map<String, dynamic> toMap() {
    return {'active': active, 'inactive': inactive};
  }

  factory UserStatusStatisticsModel.fromMap(Map<String, dynamic> map) {
    return UserStatusStatisticsModel(
      active: map.getFieldOrNull<int>('active') ?? 0,
      inactive: map.getFieldOrNull<int>('inactive') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserStatusStatisticsModel.fromJson(String source) =>
      UserStatusStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserStatusStatisticsModel(active: $active, inactive: $inactive)';
}

class UserRoleStatisticsModel extends Equatable {
  final int admin;
  final int staff;
  final int employee;

  const UserRoleStatisticsModel({
    required this.admin,
    required this.staff,
    required this.employee,
  });

  @override
  List<Object> get props => [admin, staff, employee];

  UserRoleStatisticsModel copyWith({int? admin, int? staff, int? employee}) {
    return UserRoleStatisticsModel(
      admin: admin ?? this.admin,
      staff: staff ?? this.staff,
      employee: employee ?? this.employee,
    );
  }

  Map<String, dynamic> toMap() {
    return {'admin': admin, 'staff': staff, 'employee': employee};
  }

  factory UserRoleStatisticsModel.fromMap(Map<String, dynamic> map) {
    return UserRoleStatisticsModel(
      admin: map.getFieldOrNull<int>('admin') ?? 0,
      staff: map.getFieldOrNull<int>('staff') ?? 0,
      employee: map.getFieldOrNull<int>('employee') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoleStatisticsModel.fromJson(String source) =>
      UserRoleStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserRoleStatisticsModel(admin: $admin, staff: $staff, employee: $employee)';
}

class RegistrationTrendModel extends Equatable {
  final DateTime date;
  final int count;

  const RegistrationTrendModel({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];

  RegistrationTrendModel copyWith({DateTime? date, int? count}) {
    return RegistrationTrendModel(
      date: date ?? this.date,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'count': count};
  }

  factory RegistrationTrendModel.fromMap(Map<String, dynamic> map) {
    return RegistrationTrendModel(
      date: map.getDateTime('date'),
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegistrationTrendModel.fromJson(String source) =>
      RegistrationTrendModel.fromMap(json.decode(source));

  @override
  String toString() => 'RegistrationTrendModel(date: $date, count: $count)';
}

class UserSummaryStatisticsModel extends Equatable {
  final int totalUsers;
  final double activeUsersPercentage;
  final double inactiveUsersPercentage;
  final double adminPercentage;
  final double staffPercentage;
  final double employeePercentage;
  final double averageUsersPerDay;
  final DateTime latestRegistrationDate;
  final DateTime earliestRegistrationDate;

  const UserSummaryStatisticsModel({
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
  List<Object> get props {
    return [
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

  UserSummaryStatisticsModel copyWith({
    int? totalUsers,
    double? activeUsersPercentage,
    double? inactiveUsersPercentage,
    double? adminPercentage,
    double? staffPercentage,
    double? employeePercentage,
    double? averageUsersPerDay,
    DateTime? latestRegistrationDate,
    DateTime? earliestRegistrationDate,
  }) {
    return UserSummaryStatisticsModel(
      totalUsers: totalUsers ?? this.totalUsers,
      activeUsersPercentage:
          activeUsersPercentage ?? this.activeUsersPercentage,
      inactiveUsersPercentage:
          inactiveUsersPercentage ?? this.inactiveUsersPercentage,
      adminPercentage: adminPercentage ?? this.adminPercentage,
      staffPercentage: staffPercentage ?? this.staffPercentage,
      employeePercentage: employeePercentage ?? this.employeePercentage,
      averageUsersPerDay: averageUsersPerDay ?? this.averageUsersPerDay,
      latestRegistrationDate:
          latestRegistrationDate ?? this.latestRegistrationDate,
      earliestRegistrationDate:
          earliestRegistrationDate ?? this.earliestRegistrationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalUsers': totalUsers,
      'activeUsersPercentage': activeUsersPercentage,
      'inactiveUsersPercentage': inactiveUsersPercentage,
      'adminPercentage': adminPercentage,
      'staffPercentage': staffPercentage,
      'employeePercentage': employeePercentage,
      'averageUsersPerDay': averageUsersPerDay,
      'latestRegistrationDate': latestRegistrationDate.millisecondsSinceEpoch,
      'earliestRegistrationDate':
          earliestRegistrationDate.millisecondsSinceEpoch,
    };
  }

  factory UserSummaryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return UserSummaryStatisticsModel(
      totalUsers: map.getFieldOrNull<int>('totalUsers') ?? 0,
      activeUsersPercentage:
          map.getDoubleOrNull('activeUsersPercentage') ?? 0.0,
      inactiveUsersPercentage:
          map.getDoubleOrNull('inactiveUsersPercentage') ?? 0.0,
      adminPercentage: map.getDoubleOrNull('adminPercentage') ?? 0.0,
      staffPercentage: map.getDoubleOrNull('staffPercentage') ?? 0.0,
      employeePercentage: map.getDoubleOrNull('employeePercentage') ?? 0.0,
      averageUsersPerDay: map.getDoubleOrNull('averageUsersPerDay') ?? 0.0,
      latestRegistrationDate: map.getDateTime('latestRegistrationDate'),
      earliestRegistrationDate: map.getDateTime('earliestRegistrationDate'),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserSummaryStatisticsModel.fromJson(String source) =>
      UserSummaryStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserSummaryStatisticsModel(totalUsers: $totalUsers, activeUsersPercentage: $activeUsersPercentage, inactiveUsersPercentage: $inactiveUsersPercentage, adminPercentage: $adminPercentage, staffPercentage: $staffPercentage, employeePercentage: $employeePercentage, averageUsersPerDay: $averageUsersPerDay, latestRegistrationDate: $latestRegistrationDate, earliestRegistrationDate: $earliestRegistrationDate)';
  }
}
