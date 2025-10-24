import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/data/models/notification_model.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification_statistics.dart';
import 'package:sigma_track/feature/notification/data/models/notification_statistics_model.dart';

extension NotificationModelMapper on NotificationModel {
  Notification toEntity() {
    return Notification(
      id: id,
      userId: userId,
      relatedEntityType: relatedEntityType,
      relatedEntityId: relatedEntityId,
      relatedAssetId: relatedAssetId,
      type: type,
      priority: priority,
      isRead: isRead,
      readAt: readAt,
      expiresAt: expiresAt,
      createdAt: createdAt,
      title: title,
      message: message,
      translations:
          translations?.map((model) => model.toEntity()).toList() ?? [],
    );
  }
}

extension NotificationEntityMapper on Notification {
  NotificationModel toModel() {
    return NotificationModel(
      id: id,
      userId: userId,
      relatedEntityType: relatedEntityType,
      relatedEntityId: relatedEntityId,
      relatedAssetId: relatedAssetId,
      type: type,
      priority: priority,
      isRead: isRead,
      readAt: readAt,
      expiresAt: expiresAt,
      createdAt: createdAt,
      title: title,
      message: message,
      translations:
          translations?.map((entity) => entity.toModel()).toList() ?? [],
    );
  }
}

extension NotificationTranslationModelMapper on NotificationTranslationModel {
  NotificationTranslation toEntity() {
    return NotificationTranslation(
      id: id,
      notificationId: notificationId,
      langCode: langCode,
      title: title,
      message: message,
    );
  }
}

extension NotificationTranslationEntityMapper on NotificationTranslation {
  NotificationTranslationModel toModel() {
    return NotificationTranslationModel(
      id: id,
      notificationId: notificationId,
      langCode: langCode,
      title: title,
      message: message,
    );
  }
}

extension NotificationStatisticsModelMapper on NotificationStatisticsModel {
  NotificationStatistics toEntity() {
    return NotificationStatistics(
      total: total.toEntity(),
      byType: byType.toEntity(),
      byStatus: byStatus.toEntity(),
      creationTrends: creationTrends.map((model) => model.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

extension NotificationStatisticsEntityMapper on NotificationStatistics {
  NotificationStatisticsModel toModel() {
    return NotificationStatisticsModel(
      total: total.toModel(),
      byType: byType.toModel(),
      byStatus: byStatus.toModel(),
      creationTrends: creationTrends.map((entity) => entity.toModel()).toList(),
      summary: summary.toModel(),
    );
  }
}

extension NotificationCountStatisticsModelMapper
    on NotificationCountStatisticsModel {
  NotificationCountStatistics toEntity() =>
      NotificationCountStatistics(count: count);
}

extension NotificationCountStatisticsEntityMapper
    on NotificationCountStatistics {
  NotificationCountStatisticsModel toModel() =>
      NotificationCountStatisticsModel(count: count);
}

extension NotificationTypeStatisticsModelMapper
    on NotificationTypeStatisticsModel {
  NotificationTypeStatistics toEntity() => NotificationTypeStatistics(
    maintenance: maintenance,
    warranty: warranty,
    issue: issue,
    movement: movement,
    statusChange: statusChange,
    locationChange: locationChange,
    categoryChange: categoryChange,
  );
}

extension NotificationTypeStatisticsEntityMapper on NotificationTypeStatistics {
  NotificationTypeStatisticsModel toModel() => NotificationTypeStatisticsModel(
    maintenance: maintenance,
    warranty: warranty,
    issue: issue,
    movement: movement,
    statusChange: statusChange,
    locationChange: locationChange,
    categoryChange: categoryChange,
  );
}

extension NotificationStatusStatisticsModelMapper
    on NotificationStatusStatisticsModel {
  NotificationStatusStatistics toEntity() =>
      NotificationStatusStatistics(read: read, unread: unread);
}

extension NotificationStatusStatisticsEntityMapper
    on NotificationStatusStatistics {
  NotificationStatusStatisticsModel toModel() =>
      NotificationStatusStatisticsModel(read: read, unread: unread);
}

extension NotificationCreationTrendModelMapper
    on NotificationCreationTrendModel {
  NotificationCreationTrend toEntity() =>
      NotificationCreationTrend(date: date, count: count);
}

extension NotificationCreationTrendEntityMapper on NotificationCreationTrend {
  NotificationCreationTrendModel toModel() =>
      NotificationCreationTrendModel(date: date, count: count);
}

extension NotificationSummaryStatisticsModelMapper
    on NotificationSummaryStatisticsModel {
  NotificationSummaryStatistics toEntity() => NotificationSummaryStatistics(
    totalNotifications: totalNotifications,
    readPercentage: readPercentage,
    unreadPercentage: unreadPercentage,
    mostCommonType: mostCommonType,
    averageNotificationsPerDay: averageNotificationsPerDay,
    latestCreationDate: latestCreationDate,
    earliestCreationDate: earliestCreationDate,
  );
}

extension NotificationSummaryStatisticsEntityMapper
    on NotificationSummaryStatistics {
  NotificationSummaryStatisticsModel toModel() =>
      NotificationSummaryStatisticsModel(
        totalNotifications: totalNotifications,
        readPercentage: readPercentage,
        unreadPercentage: unreadPercentage,
        mostCommonType: mostCommonType,
        averageNotificationsPerDay: averageNotificationsPerDay,
        latestCreationDate: latestCreationDate,
        earliestCreationDate: earliestCreationDate,
      );
}
