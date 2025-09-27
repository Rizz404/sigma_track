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
  final int statusChange;
  final int movement;
  final int issueReport;

  const NotificationTypeStatistics({
    required this.maintenance,
    required this.warranty,
    required this.statusChange,
    required this.movement,
    required this.issueReport,
  });

  @override
  List<Object> get props => [
    maintenance,
    warranty,
    statusChange,
    movement,
    issueReport,
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
