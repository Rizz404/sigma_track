import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class MaintenanceScheduleStatistics extends Equatable {
  final MaintenanceScheduleCountStatistics total;
  final MaintenanceTypeStatistics byType;
  final MaintenanceScheduleStatusStatistics byStatus;
  final List<AssetMaintenanceScheduleStatistics> byAsset;
  final List<UserMaintenanceScheduleStatistics> byCreator;
  final List<UpcomingMaintenanceSchedule> upcomingSchedule;
  final List<OverdueMaintenanceSchedule> overdueSchedule;
  final List<MaintenanceFrequencyTrend> frequencyTrends;
  final MaintenanceScheduleSummaryStatistics summary;

  const MaintenanceScheduleStatistics({
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
}

class MaintenanceScheduleCountStatistics extends Equatable {
  final int count;

  const MaintenanceScheduleCountStatistics({required this.count});

  @override
  List<Object> get props => [count];
}

class MaintenanceTypeStatistics extends Equatable {
  final int preventive;
  final int corrective;

  const MaintenanceTypeStatistics({
    required this.preventive,
    required this.corrective,
  });

  @override
  List<Object> get props => [preventive, corrective];
}

class MaintenanceScheduleStatusStatistics extends Equatable {
  final int scheduled;
  final int completed;
  final int cancelled;

  const MaintenanceScheduleStatusStatistics({
    required this.scheduled,
    required this.completed,
    required this.cancelled,
  });

  @override
  List<Object> get props => [scheduled, completed, cancelled];
}

class AssetMaintenanceScheduleStatistics extends Equatable {
  final String assetId;
  final String assetName;
  final String assetTag;
  final int scheduleCount;
  final String nextMaintenance;

  const AssetMaintenanceScheduleStatistics({
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
}

class UserMaintenanceScheduleStatistics extends Equatable {
  final String userId;
  final String userName;
  final String userEmail;
  final int count;

  const UserMaintenanceScheduleStatistics({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.count,
  });

  @override
  List<Object> get props => [userId, userName, userEmail, count];
}

class UpcomingMaintenanceSchedule extends Equatable {
  final String id;
  final String assetId;
  final String assetName;
  final String assetTag;
  final MaintenanceScheduleType maintenanceType;
  final DateTime scheduledDate;
  final int daysUntilDue;
  final String title;
  final String? description;

  const UpcomingMaintenanceSchedule({
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
}

class OverdueMaintenanceSchedule extends Equatable {
  final String id;
  final String assetId;
  final String assetName;
  final String assetTag;
  final MaintenanceScheduleType maintenanceType;
  final DateTime scheduledDate;
  final int daysOverdue;
  final String title;
  final String? description;

  const OverdueMaintenanceSchedule({
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
}

class MaintenanceFrequencyTrend extends Equatable {
  final int frequencyMonths;
  final int count;

  const MaintenanceFrequencyTrend({
    required this.frequencyMonths,
    required this.count,
  });

  @override
  List<Object> get props => [frequencyMonths, count];
}

class MaintenanceScheduleSummaryStatistics extends Equatable {
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

  const MaintenanceScheduleSummaryStatistics({
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
}
