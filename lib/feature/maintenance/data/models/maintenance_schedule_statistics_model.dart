import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/core/extensions/date_time_extension.dart';

class MaintenanceScheduleStatisticsModel extends Equatable {
  final MaintenanceScheduleCountStatisticsModel total;
  final MaintenanceTypeStatisticsModel byType;
  final MaintenanceScheduleStatusStatisticsModel byStatus;
  final List<AssetMaintenanceScheduleStatisticsModel> byAsset;
  final List<UserMaintenanceScheduleStatisticsModel> byCreator;
  final List<UpcomingMaintenanceScheduleModel> upcomingSchedule;
  final List<OverdueMaintenanceScheduleModel> overdueSchedule;
  final List<MaintenanceFrequencyTrendModel> frequencyTrends;
  final MaintenanceScheduleSummaryStatisticsModel summary;

  const MaintenanceScheduleStatisticsModel({
    required this.total,
    required this.byType,
    required this.byStatus,
    required this.byAsset,
    required this.byCreator,
    required this.upcomingSchedule,
    required this.overdueSchedule,
    required this.frequencyTrends,
    required this.summary,
  });

  @override
  List<Object> get props => [
    total,
    byType,
    byStatus,
    byAsset,
    byCreator,
    upcomingSchedule,
    overdueSchedule,
    frequencyTrends,
    summary,
  ];

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byType': byType.toMap(),
      'byStatus': byStatus.toMap(),
      'byAsset': byAsset.map((x) => x.toMap()).toList(),
      'byCreator': byCreator.map((x) => x.toMap()).toList(),
      'upcomingSchedule': upcomingSchedule.map((x) => x.toMap()).toList(),
      'overdueSchedule': overdueSchedule.map((x) => x.toMap()).toList(),
      'frequencyTrends': frequencyTrends.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory MaintenanceScheduleStatisticsModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceScheduleStatisticsModel(
      total: MaintenanceScheduleCountStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('total'),
      ),
      byType: MaintenanceTypeStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byType'),
      ),
      byStatus: MaintenanceScheduleStatusStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byStatus'),
      ),
      byAsset: List<AssetMaintenanceScheduleStatisticsModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('byAsset')
                ?.map(
                  (x) => AssetMaintenanceScheduleStatisticsModel.fromMap(x),
                ) ??
            [],
      ),
      byCreator: List<UserMaintenanceScheduleStatisticsModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('byCreator')
                ?.map(
                  (x) => UserMaintenanceScheduleStatisticsModel.fromMap(x),
                ) ??
            [],
      ),
      upcomingSchedule: List<UpcomingMaintenanceScheduleModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('upcomingSchedule')
                ?.map((x) => UpcomingMaintenanceScheduleModel.fromMap(x)) ??
            [],
      ),
      overdueSchedule: List<OverdueMaintenanceScheduleModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('overdueSchedule')
                ?.map((x) => OverdueMaintenanceScheduleModel.fromMap(x)) ??
            [],
      ),
      frequencyTrends: List<MaintenanceFrequencyTrendModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('frequencyTrends')
                ?.map((x) => MaintenanceFrequencyTrendModel.fromMap(x)) ??
            [],
      ),
      summary: MaintenanceScheduleSummaryStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('summary'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleStatisticsModel.fromJson(String source) =>
      MaintenanceScheduleStatisticsModel.fromMap(json.decode(source));
}

class MaintenanceScheduleCountStatisticsModel extends Equatable {
  final int count;

  const MaintenanceScheduleCountStatisticsModel({required this.count});

  @override
  List<Object> get props => [count];

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory MaintenanceScheduleCountStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceScheduleCountStatisticsModel(
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleCountStatisticsModel.fromJson(String source) =>
      MaintenanceScheduleCountStatisticsModel.fromMap(json.decode(source));
}

class MaintenanceTypeStatisticsModel extends Equatable {
  final int preventive;
  final int corrective;

  const MaintenanceTypeStatisticsModel({
    required this.preventive,
    required this.corrective,
  });

  @override
  List<Object> get props => [preventive, corrective];

  Map<String, dynamic> toMap() {
    return {'preventive': preventive, 'corrective': corrective};
  }

  factory MaintenanceTypeStatisticsModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceTypeStatisticsModel(
      preventive: map.getFieldOrNull<int>('preventive') ?? 0,
      corrective: map.getFieldOrNull<int>('corrective') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceTypeStatisticsModel.fromJson(String source) =>
      MaintenanceTypeStatisticsModel.fromMap(json.decode(source));
}

class MaintenanceScheduleStatusStatisticsModel extends Equatable {
  final int scheduled;
  final int completed;
  final int cancelled;

  const MaintenanceScheduleStatusStatisticsModel({
    required this.scheduled,
    required this.completed,
    required this.cancelled,
  });

  @override
  List<Object> get props => [scheduled, completed, cancelled];

  Map<String, dynamic> toMap() {
    return {
      'scheduled': scheduled,
      'completed': completed,
      'cancelled': cancelled,
    };
  }

  factory MaintenanceScheduleStatusStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceScheduleStatusStatisticsModel(
      scheduled: map.getFieldOrNull<int>('scheduled') ?? 0,
      completed: map.getFieldOrNull<int>('completed') ?? 0,
      cancelled: map.getFieldOrNull<int>('cancelled') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleStatusStatisticsModel.fromJson(String source) =>
      MaintenanceScheduleStatusStatisticsModel.fromMap(json.decode(source));
}

class AssetMaintenanceScheduleStatisticsModel extends Equatable {
  final String assetId;
  final String assetName;
  final String assetTag;
  final int scheduleCount;
  final String nextMaintenance;

  const AssetMaintenanceScheduleStatisticsModel({
    required this.assetId,
    required this.assetName,
    required this.assetTag,
    required this.scheduleCount,
    required this.nextMaintenance,
  });

  @override
  List<Object> get props => [
    assetId,
    assetName,
    assetTag,
    scheduleCount,
    nextMaintenance,
  ];

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'assetName': assetName,
      'assetTag': assetTag,
      'scheduleCount': scheduleCount,
      'nextMaintenance': nextMaintenance,
    };
  }

  factory AssetMaintenanceScheduleStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return AssetMaintenanceScheduleStatisticsModel(
      assetId: map.getFieldOrNull<String>('assetId') ?? '',
      assetName: map.getFieldOrNull<String>('assetName') ?? '',
      assetTag: map.getFieldOrNull<String>('assetTag') ?? '',
      scheduleCount: map.getFieldOrNull<int>('scheduleCount') ?? 0,
      nextMaintenance: map.getFieldOrNull<String>('nextMaintenance') ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetMaintenanceScheduleStatisticsModel.fromJson(String source) =>
      AssetMaintenanceScheduleStatisticsModel.fromMap(json.decode(source));
}

class UserMaintenanceScheduleStatisticsModel extends Equatable {
  final String userId;
  final String userName;
  final String userEmail;
  final int count;

  const UserMaintenanceScheduleStatisticsModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.count,
  });

  @override
  List<Object> get props => [userId, userName, userEmail, count];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'count': count,
    };
  }

  factory UserMaintenanceScheduleStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserMaintenanceScheduleStatisticsModel(
      userId: map.getFieldOrNull<String>('userId') ?? '',
      userName: map.getFieldOrNull<String>('userName') ?? '',
      userEmail: map.getFieldOrNull<String>('userEmail') ?? '',
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserMaintenanceScheduleStatisticsModel.fromJson(String source) =>
      UserMaintenanceScheduleStatisticsModel.fromMap(json.decode(source));
}

class UpcomingMaintenanceScheduleModel extends Equatable {
  final String id;
  final String assetId;
  final String assetName;
  final String assetTag;
  final MaintenanceScheduleType maintenanceType;
  final DateTime scheduledDate;
  final int daysUntilDue;
  final String title;
  final String? description;

  const UpcomingMaintenanceScheduleModel({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.assetTag,
    required this.maintenanceType,
    required this.scheduledDate,
    required this.daysUntilDue,
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    assetId,
    assetName,
    assetTag,
    maintenanceType,
    scheduledDate,
    daysUntilDue,
    title,
    description,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetId': assetId,
      'assetName': assetName,
      'assetTag': assetTag,
      'maintenanceType': maintenanceType.value,
      'scheduledDate': scheduledDate.toIso8601String(),
      'daysUntilDue': daysUntilDue,
      'title': title,
      'description': description,
    };
  }

  factory UpcomingMaintenanceScheduleModel.fromMap(Map<String, dynamic> map) {
    return UpcomingMaintenanceScheduleModel(
      id: map.getFieldOrNull<String>('id') ?? '',
      assetId: map.getFieldOrNull<String>('assetId') ?? '',
      assetName: map.getFieldOrNull<String>('assetName') ?? '',
      assetTag: map.getFieldOrNull<String>('assetTag') ?? '',
      maintenanceType: MaintenanceScheduleType.values.firstWhere(
        (e) => e.value == map.getField<String>('maintenanceType'),
      ),
      scheduledDate: map.getDateTime('scheduledDate'),
      daysUntilDue: map.getFieldOrNull<int>('daysUntilDue') ?? 0,
      title: map.getFieldOrNull<String>('title') ?? '',
      description: map.getFieldOrNull<String>('description'),
    );
  }

  String toJson() => json.encode(toMap());

  factory UpcomingMaintenanceScheduleModel.fromJson(String source) =>
      UpcomingMaintenanceScheduleModel.fromMap(json.decode(source));
}

class OverdueMaintenanceScheduleModel extends Equatable {
  final String id;
  final String assetId;
  final String assetName;
  final String assetTag;
  final MaintenanceScheduleType maintenanceType;
  final DateTime scheduledDate;
  final int daysOverdue;
  final String title;
  final String? description;

  const OverdueMaintenanceScheduleModel({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.assetTag,
    required this.maintenanceType,
    required this.scheduledDate,
    required this.daysOverdue,
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    assetId,
    assetName,
    assetTag,
    maintenanceType,
    scheduledDate,
    daysOverdue,
    title,
    description,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetId': assetId,
      'assetName': assetName,
      'assetTag': assetTag,
      'maintenanceType': maintenanceType.value,
      'scheduledDate': scheduledDate.toIso8601String(),
      'daysOverdue': daysOverdue,
      'title': title,
      'description': description,
    };
  }

  factory OverdueMaintenanceScheduleModel.fromMap(Map<String, dynamic> map) {
    return OverdueMaintenanceScheduleModel(
      id: map.getFieldOrNull<String>('id') ?? '',
      assetId: map.getFieldOrNull<String>('assetId') ?? '',
      assetName: map.getFieldOrNull<String>('assetName') ?? '',
      assetTag: map.getFieldOrNull<String>('assetTag') ?? '',
      maintenanceType: MaintenanceScheduleType.values.firstWhere(
        (e) => e.value == map.getField<String>('maintenanceType'),
      ),
      scheduledDate: map.getDateTime('scheduledDate'),
      daysOverdue: map.getFieldOrNull<int>('daysOverdue') ?? 0,
      title: map.getFieldOrNull<String>('title') ?? '',
      description: map.getFieldOrNull<String>('description'),
    );
  }

  String toJson() => json.encode(toMap());

  factory OverdueMaintenanceScheduleModel.fromJson(String source) =>
      OverdueMaintenanceScheduleModel.fromMap(json.decode(source));
}

class MaintenanceFrequencyTrendModel extends Equatable {
  final int frequencyMonths;
  final int count;

  const MaintenanceFrequencyTrendModel({
    required this.frequencyMonths,
    required this.count,
  });

  @override
  List<Object> get props => [frequencyMonths, count];

  Map<String, dynamic> toMap() {
    return {'frequencyMonths': frequencyMonths, 'count': count};
  }

  factory MaintenanceFrequencyTrendModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceFrequencyTrendModel(
      frequencyMonths: map.getFieldOrNull<int>('frequencyMonths') ?? 0,
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceFrequencyTrendModel.fromJson(String source) =>
      MaintenanceFrequencyTrendModel.fromMap(json.decode(source));
}

class MaintenanceScheduleSummaryStatisticsModel extends Equatable {
  final int totalSchedules;
  final double scheduledMaintenancePercentage;
  final double completedMaintenancePercentage;
  final double cancelledMaintenancePercentage;
  final double preventiveMaintenancePercentage;
  final double correctiveMaintenancePercentage;
  final double averageScheduleFrequency;
  final int upcomingMaintenanceCount;
  final int overdueMaintenanceCount;
  final int assetsWithScheduledMaintenance;
  final int assetsWithoutScheduledMaintenance;
  final double averageSchedulesPerDay;
  final DateTime latestScheduleDate;
  final DateTime earliestScheduleDate;
  final int totalUniqueCreators;

  const MaintenanceScheduleSummaryStatisticsModel({
    required this.totalSchedules,
    required this.scheduledMaintenancePercentage,
    required this.completedMaintenancePercentage,
    required this.cancelledMaintenancePercentage,
    required this.preventiveMaintenancePercentage,
    required this.correctiveMaintenancePercentage,
    required this.averageScheduleFrequency,
    required this.upcomingMaintenanceCount,
    required this.overdueMaintenanceCount,
    required this.assetsWithScheduledMaintenance,
    required this.assetsWithoutScheduledMaintenance,
    required this.averageSchedulesPerDay,
    required this.latestScheduleDate,
    required this.earliestScheduleDate,
    required this.totalUniqueCreators,
  });

  @override
  List<Object> get props => [
    totalSchedules,
    scheduledMaintenancePercentage,
    completedMaintenancePercentage,
    cancelledMaintenancePercentage,
    preventiveMaintenancePercentage,
    correctiveMaintenancePercentage,
    averageScheduleFrequency,
    upcomingMaintenanceCount,
    overdueMaintenanceCount,
    assetsWithScheduledMaintenance,
    assetsWithoutScheduledMaintenance,
    averageSchedulesPerDay,
    latestScheduleDate,
    earliestScheduleDate,
    totalUniqueCreators,
  ];

  Map<String, dynamic> toMap() {
    return {
      'totalSchedules': totalSchedules,
      'scheduledMaintenancePercentage': scheduledMaintenancePercentage,
      'completedMaintenancePercentage': completedMaintenancePercentage,
      'cancelledMaintenancePercentage': cancelledMaintenancePercentage,
      'preventiveMaintenancePercentage': preventiveMaintenancePercentage,
      'correctiveMaintenancePercentage': correctiveMaintenancePercentage,
      'averageScheduleFrequency': averageScheduleFrequency,
      'upcomingMaintenanceCount': upcomingMaintenanceCount,
      'overdueMaintenanceCount': overdueMaintenanceCount,
      'assetsWithScheduledMaintenance': assetsWithScheduledMaintenance,
      'assetsWithoutScheduledMaintenance': assetsWithoutScheduledMaintenance,
      'averageSchedulesPerDay': averageSchedulesPerDay,
      'latestScheduleDate': latestScheduleDate.iso8601String,
      'earliestScheduleDate': earliestScheduleDate.iso8601String,
      'totalUniqueCreators': totalUniqueCreators,
    };
  }

  factory MaintenanceScheduleSummaryStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceScheduleSummaryStatisticsModel(
      totalSchedules: map.getFieldOrNull<int>('totalSchedules') ?? 0,
      scheduledMaintenancePercentage:
          map.getDoubleOrNull('scheduledMaintenancePercentage') ?? 0.0,
      completedMaintenancePercentage:
          map.getDoubleOrNull('completedMaintenancePercentage') ?? 0.0,
      cancelledMaintenancePercentage:
          map.getDoubleOrNull('cancelledMaintenancePercentage') ?? 0.0,
      preventiveMaintenancePercentage:
          map.getDoubleOrNull('preventiveMaintenancePercentage') ?? 0.0,
      correctiveMaintenancePercentage:
          map.getDoubleOrNull('correctiveMaintenancePercentage') ?? 0.0,
      averageScheduleFrequency:
          map.getDoubleOrNull('averageScheduleFrequency') ?? 0.0,
      upcomingMaintenanceCount:
          map.getFieldOrNull<int>('upcomingMaintenanceCount') ?? 0,
      overdueMaintenanceCount:
          map.getFieldOrNull<int>('overdueMaintenanceCount') ?? 0,
      assetsWithScheduledMaintenance:
          map.getFieldOrNull<int>('assetsWithScheduledMaintenance') ?? 0,
      assetsWithoutScheduledMaintenance:
          map.getFieldOrNull<int>('assetsWithoutScheduledMaintenance') ?? 0,
      averageSchedulesPerDay:
          map.getDoubleOrNull('averageSchedulesPerDay') ?? 0.0,
      latestScheduleDate: map.getDateTime('latestScheduleDate'),
      earliestScheduleDate: map.getDateTime('earliestScheduleDate'),
      totalUniqueCreators: map.getFieldOrNull<int>('totalUniqueCreators') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleSummaryStatisticsModel.fromJson(String source) =>
      MaintenanceScheduleSummaryStatisticsModel.fromMap(json.decode(source));
}
