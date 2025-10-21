import 'package:flutter_test/flutter_test.dart';
import 'package:sigma_track/feature/notification/data/models/notification_statistics_model.dart';

void main() {
  test(
    'NotificationStatisticsModel.fromJson parses API response correctly',
    () {
      const jsonString = '''
{
  "total": {
    "count": 32
  },
  "byType": {
    "maintenance": 0,
    "warranty": 2,
    "statusChange": 23,
    "movement": 5,
    "issueReport": 2
  },
  "byStatus": {
    "read": 0,
    "unread": 32
  },
  "creationTrends": [
    {
      "date": "2025-10-21T00:00:00Z",
      "count": 2
    },
    {
      "date": "2025-10-20T00:00:00Z",
      "count": 8
    },
    {
      "date": "2025-10-19T00:00:00Z",
      "count": 8
    },
    {
      "date": "2025-10-16T00:00:00Z",
      "count": 5
    },
    {
      "date": "2025-10-15T00:00:00Z",
      "count": 9
    }
  ],
  "summary": {
    "totalNotifications": 32,
    "readPercentage": 0,
    "unreadPercentage": 100,
    "mostCommonType": "STATUS_CHANGE",
    "averageNotificationsPerDay": 5.33,
    "latestCreationDate": "2025-10-21T02:46:51.612302Z",
    "earliestCreationDate": "2025-10-15T02:39:14.630685Z"
  }
}
''';

      final model = NotificationStatisticsModel.fromJson(jsonString);

      expect(model.total.count, 32);
      expect(model.byType.maintenance, 0);
      expect(model.byType.warranty, 2);
      expect(model.byType.statusChange, 23);
      expect(model.byType.movement, 5);
      expect(model.byType.issueReport, 2);
      expect(model.byStatus.read, 0);
      expect(model.byStatus.unread, 32);
      expect(model.creationTrends.length, 5);
      expect(
        model.creationTrends[0].date,
        DateTime.parse("2025-10-21T00:00:00Z"),
      );
      expect(model.creationTrends[0].count, 2);
      expect(model.summary.totalNotifications, 32);
      expect(model.summary.readPercentage, 0.0);
      expect(model.summary.unreadPercentage, 100.0);
      expect(model.summary.mostCommonType, "STATUS_CHANGE");
      expect(model.summary.averageNotificationsPerDay, 5.33);
      expect(
        model.summary.latestCreationDate,
        DateTime.parse("2025-10-21T02:46:51.612302Z"),
      );
      expect(
        model.summary.earliestCreationDate,
        DateTime.parse("2025-10-15T02:39:14.630685Z"),
      );
    },
  );
}
