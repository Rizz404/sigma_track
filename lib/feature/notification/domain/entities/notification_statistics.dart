import 'package:equatable/equatable.dart';

class NotificationStatistics extends Equatable {
  final NotificationCountStatistics total;
  final NotificationTypeStatistics byType;
  final NotificationStatusStatistics byStatus;
  final List<NotificationCreationTrend> creationTrends;
  final NotificationSummaryStatistics summary;

  const NotificationStatistics({
    required this.total,
    required this.byType,
    required this.byStatus,
    required this.creationTrends,
    required this.summary,
  });

  factory NotificationStatistics.dummy() => NotificationStatistics(
    total: const NotificationCountStatistics(count: 0),
    byType: const NotificationTypeStatistics(
      maintenance: 0,
      warranty: 0,
      issue: 0,
      movement: 0,
      statusChange: 0,
      locationChange: 0,
      categoryChange: 0,
    ),
    byStatus: const NotificationStatusStatistics(read: 0, unread: 0),
    creationTrends: const [],
    summary: NotificationSummaryStatistics(
      totalNotifications: 0,
      readPercentage: 0.0,
      unreadPercentage: 0.0,
      mostCommonType: '',
      averageNotificationsPerDay: 0.0,
      latestCreationDate: DateTime(0),
      earliestCreationDate: DateTime(0),
    ),
  );

  @override
  List<Object> get props => [total, byType, byStatus, creationTrends, summary];
}

class NotificationCountStatistics extends Equatable {
  final int count;

  const NotificationCountStatistics({required this.count});

  @override
  List<Object> get props => [count];
}

class NotificationTypeStatistics extends Equatable {
  final int maintenance;
  final int warranty;
  final int issue;
  final int movement;
  final int statusChange;
  final int locationChange;
  final int categoryChange;

  const NotificationTypeStatistics({
    required this.maintenance,
    required this.warranty,
    required this.issue,
    required this.movement,
    required this.statusChange,
    required this.locationChange,
    required this.categoryChange,
  });

  @override
  List<Object> get props => [
    maintenance,
    warranty,
    issue,
    movement,
    statusChange,
    locationChange,
    categoryChange,
  ];
}

class NotificationStatusStatistics extends Equatable {
  final int read;
  final int unread;

  const NotificationStatusStatistics({
    required this.read,
    required this.unread,
  });

  @override
  List<Object> get props => [read, unread];
}

class NotificationCreationTrend extends Equatable {
  final DateTime date;
  final int count;

  const NotificationCreationTrend({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];
}

class NotificationSummaryStatistics extends Equatable {
  final int totalNotifications;
  final double readPercentage;
  final double unreadPercentage;
  final String mostCommonType;
  final double averageNotificationsPerDay;
  final DateTime latestCreationDate;
  final DateTime earliestCreationDate;

  const NotificationSummaryStatistics({
    required this.totalNotifications,
    required this.readPercentage,
    required this.unreadPercentage,
    required this.mostCommonType,
    required this.averageNotificationsPerDay,
    required this.latestCreationDate,
    required this.earliestCreationDate,
  });

  @override
  List<Object> get props => [
    totalNotifications,
    readPercentage,
    unreadPercentage,
    mostCommonType,
    averageNotificationsPerDay,
    latestCreationDate,
    earliestCreationDate,
  ];
}
