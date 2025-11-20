import 'package:sigma_track/feature/asset/data/mapper/asset_mappers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule_statistics.dart';
import 'package:sigma_track/feature/maintenance/data/models/maintenance_schedule_model.dart';
import 'package:sigma_track/feature/maintenance/data/models/maintenance_schedule_statistics_model.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';

extension MaintenanceScheduleModelMapper on MaintenanceScheduleModel {
  MaintenanceSchedule toEntity() {
    return MaintenanceSchedule(
      id: id,
      assetId: assetId,
      maintenanceType: maintenanceType,
      isRecurring: isRecurring,
      intervalValue: intervalValue,
      intervalUnit: intervalUnit,
      scheduledTime: scheduledTime,
      nextScheduledDate: nextScheduledDate,
      lastExecutedDate: lastExecutedDate,
      state: state,
      autoComplete: autoComplete,
      estimatedCost: estimatedCost,
      createdById: createdById,
      createdAt: createdAt,
      updatedAt: updatedAt,
      title: title,
      description: description,
      translations: translations?.map((x) => x.toEntity()).toList() ?? [],
      asset: asset?.toEntity(),
      createdBy: createdBy?.toEntity(),
    );
  }
}

extension MaintenanceScheduleEntityMapper on MaintenanceSchedule {
  MaintenanceScheduleModel toModel() {
    return MaintenanceScheduleModel(
      id: id,
      assetId: assetId,
      maintenanceType: maintenanceType,
      isRecurring: isRecurring,
      intervalValue: intervalValue,
      intervalUnit: intervalUnit,
      scheduledTime: scheduledTime,
      nextScheduledDate: nextScheduledDate,
      lastExecutedDate: lastExecutedDate,
      state: state,
      autoComplete: autoComplete,
      estimatedCost: estimatedCost,
      createdById: createdById,
      createdAt: createdAt,
      updatedAt: updatedAt,
      title: title,
      description: description,
      translations: translations?.map((x) => x.toModel()).toList() ?? [],
      asset: asset?.toModel(),
      createdBy: createdBy?.toModel(),
    );
  }
}

extension MaintenanceScheduleTranslationModelMapper
    on MaintenanceScheduleTranslationModel {
  MaintenanceScheduleTranslation toEntity() {
    return MaintenanceScheduleTranslation(
      langCode: langCode,
      title: title,
      description: description,
    );
  }
}

extension MaintenanceScheduleTranslationEntityMapper
    on MaintenanceScheduleTranslation {
  MaintenanceScheduleTranslationModel toModel() {
    return MaintenanceScheduleTranslationModel(
      langCode: langCode,
      title: title,
      description: description,
    );
  }
}

extension MaintenanceScheduleStatisticsModelMapper
    on MaintenanceScheduleStatisticsModel {
  MaintenanceScheduleStatistics toEntity() {
    return MaintenanceScheduleStatistics(
      total: total.toEntity(),
      byType: byType.toEntity(),
      byStatus: byStatus.toEntity(),
      byAsset: byAsset.map((x) => x.toEntity()).toList(),
      byCreator: byCreator.map((x) => x.toEntity()).toList(),
      upcomingSchedule: upcomingSchedule.map((x) => x.toEntity()).toList(),
      overdueSchedule: overdueSchedule.map((x) => x.toEntity()).toList(),
      frequencyTrends: frequencyTrends.map((x) => x.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

extension MaintenanceScheduleStatisticsEntityMapper
    on MaintenanceScheduleStatistics {
  MaintenanceScheduleStatisticsModel toModel() {
    return MaintenanceScheduleStatisticsModel(
      total: total.toModel(),
      byType: byType.toModel(),
      byStatus: byStatus.toModel(),
      byAsset: byAsset.map((x) => x.toModel()).toList(),
      byCreator: byCreator.map((x) => x.toModel()).toList(),
      upcomingSchedule: upcomingSchedule.map((x) => x.toModel()).toList(),
      overdueSchedule: overdueSchedule.map((x) => x.toModel()).toList(),
      frequencyTrends: frequencyTrends.map((x) => x.toModel()).toList(),
      summary: summary.toModel(),
    );
  }
}

extension MaintenanceScheduleCountStatisticsModelMapper
    on MaintenanceScheduleCountStatisticsModel {
  MaintenanceScheduleCountStatistics toEntity() {
    return MaintenanceScheduleCountStatistics(count: count);
  }
}

extension MaintenanceScheduleCountStatisticsEntityMapper
    on MaintenanceScheduleCountStatistics {
  MaintenanceScheduleCountStatisticsModel toModel() {
    return MaintenanceScheduleCountStatisticsModel(count: count);
  }
}

extension MaintenanceTypeStatisticsModelMapper
    on MaintenanceTypeStatisticsModel {
  MaintenanceTypeStatistics toEntity() {
    return MaintenanceTypeStatistics(
      preventive: preventive,
      corrective: corrective,
      inspection: inspection,
      calibration: calibration,
    );
  }
}

extension MaintenanceTypeStatisticsEntityMapper on MaintenanceTypeStatistics {
  MaintenanceTypeStatisticsModel toModel() {
    return MaintenanceTypeStatisticsModel(
      preventive: preventive,
      corrective: corrective,
      inspection: inspection,
      calibration: calibration,
    );
  }
}

extension MaintenanceScheduleStatusStatisticsModelMapper
    on MaintenanceScheduleStatusStatisticsModel {
  MaintenanceScheduleStatusStatistics toEntity() {
    return MaintenanceScheduleStatusStatistics(
      active: active,
      paused: paused,
      stopped: stopped,
      completed: completed,
    );
  }
}

extension MaintenanceScheduleStatusStatisticsEntityMapper
    on MaintenanceScheduleStatusStatistics {
  MaintenanceScheduleStatusStatisticsModel toModel() {
    return MaintenanceScheduleStatusStatisticsModel(
      active: active,
      paused: paused,
      stopped: stopped,
      completed: completed,
    );
  }
}

extension AssetMaintenanceScheduleStatisticsModelMapper
    on AssetMaintenanceScheduleStatisticsModel {
  AssetMaintenanceScheduleStatistics toEntity() {
    return AssetMaintenanceScheduleStatistics(
      assetId: assetId,
      assetName: assetName,
      assetTag: assetTag,
      scheduleCount: scheduleCount,
      nextMaintenance: nextMaintenance,
    );
  }
}

extension AssetMaintenanceScheduleStatisticsEntityMapper
    on AssetMaintenanceScheduleStatistics {
  AssetMaintenanceScheduleStatisticsModel toModel() {
    return AssetMaintenanceScheduleStatisticsModel(
      assetId: assetId,
      assetName: assetName,
      assetTag: assetTag,
      scheduleCount: scheduleCount,
      nextMaintenance: nextMaintenance,
    );
  }
}

extension UserMaintenanceScheduleStatisticsModelMapper
    on UserMaintenanceScheduleStatisticsModel {
  UserMaintenanceScheduleStatistics toEntity() {
    return UserMaintenanceScheduleStatistics(
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      count: count,
    );
  }
}

extension UserMaintenanceScheduleStatisticsEntityMapper
    on UserMaintenanceScheduleStatistics {
  UserMaintenanceScheduleStatisticsModel toModel() {
    return UserMaintenanceScheduleStatisticsModel(
      userId: userId,
      userName: userName,
      userEmail: userEmail,
      count: count,
    );
  }
}

extension UpcomingMaintenanceScheduleModelMapper
    on UpcomingMaintenanceScheduleModel {
  UpcomingMaintenanceSchedule toEntity() {
    return UpcomingMaintenanceSchedule(
      id: id,
      assetId: assetId,
      assetName: assetName,
      assetTag: assetTag,
      maintenanceType: maintenanceType,
      nextScheduledDate: nextScheduledDate,
      daysUntilDue: daysUntilDue,
      title: title,
      description: description,
    );
  }
}

extension UpcomingMaintenanceScheduleEntityMapper
    on UpcomingMaintenanceSchedule {
  UpcomingMaintenanceScheduleModel toModel() {
    return UpcomingMaintenanceScheduleModel(
      id: id,
      assetId: assetId,
      assetName: assetName,
      assetTag: assetTag,
      maintenanceType: maintenanceType,
      nextScheduledDate: nextScheduledDate,
      daysUntilDue: daysUntilDue,
      title: title,
      description: description,
    );
  }
}

extension OverdueMaintenanceScheduleModelMapper
    on OverdueMaintenanceScheduleModel {
  OverdueMaintenanceSchedule toEntity() {
    return OverdueMaintenanceSchedule(
      id: id,
      assetId: assetId,
      assetName: assetName,
      assetTag: assetTag,
      maintenanceType: maintenanceType,
      nextScheduledDate: nextScheduledDate,
      daysOverdue: daysOverdue,
      title: title,
      description: description,
    );
  }
}

extension OverdueMaintenanceScheduleEntityMapper on OverdueMaintenanceSchedule {
  OverdueMaintenanceScheduleModel toModel() {
    return OverdueMaintenanceScheduleModel(
      id: id,
      assetId: assetId,
      assetName: assetName,
      assetTag: assetTag,
      maintenanceType: maintenanceType,
      nextScheduledDate: nextScheduledDate,
      daysOverdue: daysOverdue,
      title: title,
      description: description,
    );
  }
}

extension MaintenanceFrequencyTrendModelMapper
    on MaintenanceFrequencyTrendModel {
  MaintenanceFrequencyTrend toEntity() {
    return MaintenanceFrequencyTrend(
      frequencyMonths: frequencyMonths,
      count: count,
    );
  }
}

extension MaintenanceFrequencyTrendEntityMapper on MaintenanceFrequencyTrend {
  MaintenanceFrequencyTrendModel toModel() {
    return MaintenanceFrequencyTrendModel(
      frequencyMonths: frequencyMonths,
      count: count,
    );
  }
}

extension MaintenanceScheduleSummaryStatisticsModelMapper
    on MaintenanceScheduleSummaryStatisticsModel {
  MaintenanceScheduleSummaryStatistics toEntity() {
    return MaintenanceScheduleSummaryStatistics(
      totalSchedules: totalSchedules,
      activeMaintenancePercentage: activeMaintenancePercentage,
      pausedMaintenancePercentage: pausedMaintenancePercentage,
      stoppedMaintenancePercentage: stoppedMaintenancePercentage,
      completedMaintenancePercentage: completedMaintenancePercentage,
      preventiveMaintenancePercentage: preventiveMaintenancePercentage,
      correctiveMaintenancePercentage: correctiveMaintenancePercentage,
      inspectionMaintenancePercentage: inspectionMaintenancePercentage,
      calibrationMaintenancePercentage: calibrationMaintenancePercentage,
      averageScheduleFrequency: averageScheduleFrequency,
      upcomingMaintenanceCount: upcomingMaintenanceCount,
      overdueMaintenanceCount: overdueMaintenanceCount,
      assetsWithScheduledMaintenance: assetsWithScheduledMaintenance,
      assetsWithoutScheduledMaintenance: assetsWithoutScheduledMaintenance,
      averageSchedulesPerDay: averageSchedulesPerDay,
      latestScheduleDate: latestScheduleDate,
      earliestScheduleDate: earliestScheduleDate,
      totalUniqueCreators: totalUniqueCreators,
    );
  }
}

extension MaintenanceScheduleSummaryStatisticsEntityMapper
    on MaintenanceScheduleSummaryStatistics {
  MaintenanceScheduleSummaryStatisticsModel toModel() {
    return MaintenanceScheduleSummaryStatisticsModel(
      totalSchedules: totalSchedules,
      activeMaintenancePercentage: activeMaintenancePercentage,
      pausedMaintenancePercentage: pausedMaintenancePercentage,
      stoppedMaintenancePercentage: stoppedMaintenancePercentage,
      completedMaintenancePercentage: completedMaintenancePercentage,
      preventiveMaintenancePercentage: preventiveMaintenancePercentage,
      correctiveMaintenancePercentage: correctiveMaintenancePercentage,
      inspectionMaintenancePercentage: inspectionMaintenancePercentage,
      calibrationMaintenancePercentage: calibrationMaintenancePercentage,
      averageScheduleFrequency: averageScheduleFrequency,
      upcomingMaintenanceCount: upcomingMaintenanceCount,
      overdueMaintenanceCount: overdueMaintenanceCount,
      assetsWithScheduledMaintenance: assetsWithScheduledMaintenance,
      assetsWithoutScheduledMaintenance: assetsWithoutScheduledMaintenance,
      averageSchedulesPerDay: averageSchedulesPerDay,
      latestScheduleDate: latestScheduleDate,
      earliestScheduleDate: earliestScheduleDate,
      totalUniqueCreators: totalUniqueCreators,
    );
  }
}
