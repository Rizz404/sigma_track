import 'package:flutter_test/flutter_test.dart';
import 'package:sigma_track/feature/asset_movement/data/models/asset_movement_statistics_model.dart';

void main() {
  test(
    'AssetMovementStatisticsModel.fromJson parses API response correctly',
    () {
      const jsonString = '''
{
  "total": {
    "count": 6
  },
  "byAsset": [
    {
      "assetId": "01K7ZQ8TNA8C1M379T0537H1B2",
      "assetTag": "VEHICLES_CARS-00013",
      "assetName": "Test",
      "movementCount": 3
    },
    {
      "assetId": "01K7GX9MZBJF4V3T7M3Z3XDYYD",
      "assetTag": "AST-000011",
      "assetName": "Panasonic Air Conditioner OrD",
      "movementCount": 2
    },
    {
      "assetId": "01K7R5HGEEQZN9KYXHRTGRQM5R",
      "assetTag": "ELECTRONICS000002",
      "assetName": "Printer Epson ",
      "movementCount": 1
    }
  ],
  "byLocation": [
    {
      "locationId": "01K7GYY1BEJVKMR8DR4GN181C6",
      "locationCode": "MTG_MO_2F_013",
      "locationName": "Main Office - Meeting",
      "incomingCount": 0,
      "outgoingCount": 4,
      "netMovement": -4
    },
    {
      "locationId": "01K7GX9MWZB5PQZ5WT0GXNQQ3F",
      "locationCode": "RCP_MO_4F_012",
      "locationName": "Main Office - Reception",
      "incomingCount": 0,
      "outgoingCount": 2,
      "netMovement": -2
    },
    {
      "locationId": "01K7GYY1C4Y68G0GMX6Y79MJRX",
      "locationCode": "OFF_AN_4F_017",
      "locationName": "Annex Building - Office",
      "incomingCount": 2,
      "outgoingCount": 0,
      "netMovement": 2
    },
    {
      "locationId": "01K7GYY1B8TNNSKEBDE128P8TW",
      "locationCode": "OFF_MO_1F_012",
      "locationName": "Main Office - Office",
      "incomingCount": 1,
      "outgoingCount": 0,
      "netMovement": 1
    },
    {
      "locationId": "01K7GYY1BYM47DYHX0J9TSNY55",
      "locationCode": "BRK_T2_2F_016",
      "locationName": "Tower 2 - Break Room",
      "incomingCount": 1,
      "outgoingCount": 0,
      "netMovement": 1
    },
    {
      "locationId": "01K7GYY1CF6V0BZDTF6Q96VF0W",
      "locationCode": "STG_T2_3F_019",
      "locationName": "Tower 2 - Storage",
      "incomingCount": 1,
      "outgoingCount": 0,
      "netMovement": 1
    }
  ],
  "byUser": [
    {
      "userId": "01K7GX8Z785M09XKSZHHW53KZ7",
      "userName": "admin",
      "movementCount": 6
    }
  ],
  "byMovementType": {
    "locationToLocation": 5,
    "locationToUser": 1,
    "userToLocation": 4,
    "userToUser": 1,
    "newAsset": 0
  },
  "recentMovements": [
    {
      "id": "01K7ZRPKFHNWMSZF6G08JFK6AG",
      "assetTag": "VEHICLES_CARS-00013",
      "assetName": "Test",
      "fromLocation": "MTG_MO_2F_013",
      "toLocation": "",
      "fromUser": "admin",
      "toUser": "Dika",
      "movedBy": "admin",
      "movementDate": "2025-10-20T02:55:43.600947Z",
      "movementType": "Location to User"
    },
    {
      "id": "01K7ZQWQHK60RND3X4HP06EWR8",
      "assetTag": "VEHICLES_CARS-00013",
      "assetName": "Test",
      "fromLocation": "MTG_MO_2F_013",
      "toLocation": "OFF_MO_1F_012",
      "fromUser": "admin",
      "toUser": "",
      "movedBy": "admin",
      "movementDate": "2025-10-20T02:41:35.794583Z",
      "movementType": "Location to Location"
    },
    {
      "id": "01K7ZQARXBHMXHJBF6DKS66MW2",
      "assetTag": "VEHICLES_CARS-00013",
      "assetName": "Test",
      "fromLocation": "MTG_MO_2F_013",
      "toLocation": "BRK_T2_2F_016",
      "fromUser": "admin",
      "toUser": "",
      "movedBy": "admin",
      "movementDate": "2025-10-20T02:31:47.370788Z",
      "movementType": "Location to Location"
    },
    {
      "id": "01K7RPN2J0NM2AEQQWT3X38QM5",
      "assetTag": "ELECTRONICS000002",
      "assetName": "Printer Epson ",
      "fromLocation": "MTG_MO_2F_013",
      "toLocation": "STG_T2_3F_019",
      "fromUser": "",
      "toUser": "",
      "movedBy": "admin",
      "movementDate": "2025-10-17T09:05:15.328102Z",
      "movementType": "Location to Location"
    },
    {
      "id": "01K7P6QM3WCH11Z7QKCQ9XFS9J",
      "assetTag": "AST-000011",
      "assetName": "Panasonic Air Conditioner OrD",
      "fromLocation": "RCP_MO_4F_012",
      "toLocation": "OFF_AN_4F_017",
      "fromUser": "Tegar",
      "toUser": "",
      "movedBy": "admin",
      "movementDate": "2025-10-16T09:48:32.763469Z",
      "movementType": "Location to Location"
    },
    {
      "id": "01K7P6QDQTHXH3ADZR0CTPNYCS",
      "assetTag": "AST-000011",
      "assetName": "Panasonic Air Conditioner OrD",
      "fromLocation": "RCP_MO_4F_012",
      "toLocation": "OFF_AN_4F_017",
      "fromUser": "Tegar",
      "toUser": "",
      "movedBy": "admin",
      "movementDate": "2025-10-16T09:48:26.23443Z",
      "movementType": "Location to Location"
    }
  ],
  "movementTrends": [
    {
      "date": "2025-10-20T00:00:00Z",
      "count": 3
    },
    {
      "date": "2025-10-17T00:00:00Z",
      "count": 1
    },
    {
      "date": "2025-10-16T00:00:00Z",
      "count": 2
    }
  ],
  "summary": {
    "totalMovements": 6,
    "movementsToday": 0,
    "movementsThisWeek": 3,
    "movementsThisMonth": 6,
    "mostActiveAsset": "VEHICLES_CARS-00013",
    "mostActiveLocation": "MTG_MO_2F_013",
    "mostActiveUser": "admin",
    "averageMovementsPerDay": 1.62,
    "averageMovementsPerAsset": 2,
    "latestMovementDate": "2025-10-20T02:55:43.600947Z",
    "earliestMovementDate": "2025-10-16T09:48:26.23443Z",
    "uniqueAssetsWithMovements": 3,
    "uniqueLocationsInvolved": 6,
    "uniqueUsersInvolved": 3
  }
}
''';

      final model = AssetMovementStatisticsModel.fromJson(jsonString);

      expect(model.total.count, 6);
      expect(model.byAsset.length, 3);
      expect(model.byAsset[0].assetTag, "VEHICLES_CARS-00013");
      expect(model.byLocation.length, 6);
      expect(model.byLocation[0].locationCode, "MTG_MO_2F_013");
      expect(model.byUser.length, 1);
      expect(model.byUser[0].userName, "admin");
      expect(model.byMovementType.locationToLocation, 5);
      expect(model.recentMovements.length, 6);
      expect(model.recentMovements[0].assetTag, "VEHICLES_CARS-00013");
      expect(model.movementTrends.length, 3);
      expect(model.movementTrends[0].date, "2025-10-20T00:00:00Z");
      expect(model.summary.totalMovements, 6);
      expect(model.summary.mostActiveAsset, "VEHICLES_CARS-00013");
      expect(model.summary.averageMovementsPerDay, 1.62);
      expect(
        model.summary.latestMovementDate,
        DateTime.parse("2025-10-20T02:55:43.600947Z"),
      );
    },
  );
}
