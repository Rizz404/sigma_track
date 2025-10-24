import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class NotificationStatisticsModel extends Equatable {
  final NotificationCountStatisticsModel total;
  final NotificationTypeStatisticsModel byType;
  final NotificationStatusStatisticsModel byStatus;
  final List<NotificationCreationTrendModel> creationTrends;
  final NotificationSummaryStatisticsModel summary;

  const NotificationStatisticsModel({
    required this.total,
    required this.byType,
    required this.byStatus,
    required this.creationTrends,
    required this.summary,
  });

  @override
  List<Object> get props => [total, byType, byStatus, creationTrends, summary];

  NotificationStatisticsModel copyWith({
    NotificationCountStatisticsModel? total,
    NotificationTypeStatisticsModel? byType,
    NotificationStatusStatisticsModel? byStatus,
    List<NotificationCreationTrendModel>? creationTrends,
    NotificationSummaryStatisticsModel? summary,
  }) {
    return NotificationStatisticsModel(
      total: total ?? this.total,
      byType: byType ?? this.byType,
      byStatus: byStatus ?? this.byStatus,
      creationTrends: creationTrends ?? this.creationTrends,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byType': byType.toMap(),
      'byStatus': byStatus.toMap(),
      'creationTrends': creationTrends.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory NotificationStatisticsModel.fromMap(Map<String, dynamic> map) {
    return NotificationStatisticsModel(
      total: NotificationCountStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('total'),
      ),
      byType: NotificationTypeStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byType'),
      ),
      byStatus: NotificationStatusStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('byStatus'),
      ),
      creationTrends: List<NotificationCreationTrendModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('creationTrends')
                ?.map(
                  (x) => NotificationCreationTrendModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
      summary: NotificationSummaryStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('summary'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationStatisticsModel.fromJson(String source) =>
      NotificationStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationStatisticsModel(total: $total, byType: $byType, byStatus: $byStatus, creationTrends: $creationTrends, summary: $summary)';
  }
}

class NotificationCountStatisticsModel extends Equatable {
  final int count;

  const NotificationCountStatisticsModel({required this.count});

  @override
  List<Object> get props => [count];

  NotificationCountStatisticsModel copyWith({int? count}) {
    return NotificationCountStatisticsModel(count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory NotificationCountStatisticsModel.fromMap(Map<String, dynamic> map) {
    return NotificationCountStatisticsModel(
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationCountStatisticsModel.fromJson(String source) =>
      NotificationCountStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() => 'NotificationCountStatisticsModel(count: $count)';
}

class NotificationTypeStatisticsModel extends Equatable {
  final int maintenance;
  final int warranty;
  final int issue;
  final int movement;
  final int statusChange;
  final int locationChange;
  final int categoryChange;

  const NotificationTypeStatisticsModel({
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

  NotificationTypeStatisticsModel copyWith({
    int? maintenance,
    int? warranty,
    int? issue,
    int? movement,
    int? statusChange,
    int? locationChange,
    int? categoryChange,
  }) {
    return NotificationTypeStatisticsModel(
      maintenance: maintenance ?? this.maintenance,
      warranty: warranty ?? this.warranty,
      issue: issue ?? this.issue,
      movement: movement ?? this.movement,
      statusChange: statusChange ?? this.statusChange,
      locationChange: locationChange ?? this.locationChange,
      categoryChange: categoryChange ?? this.categoryChange,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'maintenance': maintenance,
      'warranty': warranty,
      'issue': issue,
      'movement': movement,
      'statusChange': statusChange,
      'locationChange': locationChange,
      'categoryChange': categoryChange,
    };
  }

  factory NotificationTypeStatisticsModel.fromMap(Map<String, dynamic> map) {
    return NotificationTypeStatisticsModel(
      maintenance: map.getFieldOrNull<int>('maintenance') ?? 0,
      warranty: map.getFieldOrNull<int>('warranty') ?? 0,
      issue: map.getFieldOrNull<int>('issue') ?? 0,
      movement: map.getFieldOrNull<int>('movement') ?? 0,
      statusChange: map.getFieldOrNull<int>('statusChange') ?? 0,
      locationChange: map.getFieldOrNull<int>('locationChange') ?? 0,
      categoryChange: map.getFieldOrNull<int>('categoryChange') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationTypeStatisticsModel.fromJson(String source) =>
      NotificationTypeStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'NotificationTypeStatisticsModel(maintenance: $maintenance, warranty: $warranty, issue: $issue, movement: $movement, statusChange: $statusChange, locationChange: $locationChange, categoryChange: $categoryChange)';
}

class NotificationStatusStatisticsModel extends Equatable {
  final int read;
  final int unread;

  const NotificationStatusStatisticsModel({
    required this.read,
    required this.unread,
  });

  @override
  List<Object> get props => [read, unread];

  NotificationStatusStatisticsModel copyWith({int? read, int? unread}) {
    return NotificationStatusStatisticsModel(
      read: read ?? this.read,
      unread: unread ?? this.unread,
    );
  }

  Map<String, dynamic> toMap() {
    return {'read': read, 'unread': unread};
  }

  factory NotificationStatusStatisticsModel.fromMap(Map<String, dynamic> map) {
    return NotificationStatusStatisticsModel(
      read: map.getFieldOrNull<int>('read') ?? 0,
      unread: map.getFieldOrNull<int>('unread') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationStatusStatisticsModel.fromJson(String source) =>
      NotificationStatusStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'NotificationStatusStatisticsModel(read: $read, unread: $unread)';
}

class NotificationCreationTrendModel extends Equatable {
  final DateTime date;
  final int count;

  const NotificationCreationTrendModel({
    required this.date,
    required this.count,
  });

  @override
  List<Object> get props => [date, count];

  NotificationCreationTrendModel copyWith({DateTime? date, int? count}) {
    return NotificationCreationTrendModel(
      date: date ?? this.date,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'count': count};
  }

  factory NotificationCreationTrendModel.fromMap(Map<String, dynamic> map) {
    return NotificationCreationTrendModel(
      date: map.getField<DateTime>('date'),
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationCreationTrendModel.fromJson(String source) =>
      NotificationCreationTrendModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'NotificationCreationTrendModel(date: $date, count: $count)';
}

class NotificationSummaryStatisticsModel extends Equatable {
  final int totalNotifications;
  final double readPercentage;
  final double unreadPercentage;
  final String mostCommonType;
  final double averageNotificationsPerDay;
  final DateTime latestCreationDate;
  final DateTime earliestCreationDate;

  const NotificationSummaryStatisticsModel({
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

  NotificationSummaryStatisticsModel copyWith({
    int? totalNotifications,
    double? readPercentage,
    double? unreadPercentage,
    String? mostCommonType,
    double? averageNotificationsPerDay,
    DateTime? latestCreationDate,
    DateTime? earliestCreationDate,
  }) {
    return NotificationSummaryStatisticsModel(
      totalNotifications: totalNotifications ?? this.totalNotifications,
      readPercentage: readPercentage ?? this.readPercentage,
      unreadPercentage: unreadPercentage ?? this.unreadPercentage,
      mostCommonType: mostCommonType ?? this.mostCommonType,
      averageNotificationsPerDay:
          averageNotificationsPerDay ?? this.averageNotificationsPerDay,
      latestCreationDate: latestCreationDate ?? this.latestCreationDate,
      earliestCreationDate: earliestCreationDate ?? this.earliestCreationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalNotifications': totalNotifications,
      'readPercentage': readPercentage,
      'unreadPercentage': unreadPercentage,
      'mostCommonType': mostCommonType,
      'averageNotificationsPerDay': averageNotificationsPerDay,
      'latestCreationDate': latestCreationDate.toIso8601String(),
      'earliestCreationDate': earliestCreationDate.toIso8601String(),
    };
  }

  factory NotificationSummaryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return NotificationSummaryStatisticsModel(
      totalNotifications: map.getFieldOrNull<int>('totalNotifications') ?? 0,
      readPercentage: map.getFieldOrNull<double>('readPercentage') ?? 0.0,
      unreadPercentage: map.getFieldOrNull<double>('unreadPercentage') ?? 0.0,
      mostCommonType: map.getFieldOrNull<String>('mostCommonType') ?? '',
      averageNotificationsPerDay:
          map.getFieldOrNull<double>('averageNotificationsPerDay') ?? 0.0,
      latestCreationDate: map.getField<DateTime>('latestCreationDate'),
      earliestCreationDate: map.getField<DateTime>('earliestCreationDate'),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationSummaryStatisticsModel.fromJson(String source) =>
      NotificationSummaryStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationSummaryStatisticsModel(totalNotifications: $totalNotifications, readPercentage: $readPercentage, unreadPercentage: $unreadPercentage, mostCommonType: $mostCommonType, averageNotificationsPerDay: $averageNotificationsPerDay, latestCreationDate: $latestCreationDate, earliestCreationDate: $earliestCreationDate)';
  }
}
