import 'dart:convert';

class AssetMovementCountStatisticsModel {
  final int count;

  const AssetMovementCountStatisticsModel({required this.count});

  AssetMovementCountStatisticsModel copyWith({int? count}) {
    return AssetMovementCountStatisticsModel(count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory AssetMovementCountStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementCountStatisticsModel(count: map['count'] as int);
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementCountStatisticsModel.fromJson(String source) =>
      AssetMovementCountStatisticsModel.fromMap(jsonDecode(source));
}

class AssetMovementByAssetStatsModel {
  final String assetID;
  final String assetTag;
  final String assetName;
  final int movementCount;

  const AssetMovementByAssetStatsModel({
    required this.assetID,
    required this.assetTag,
    required this.assetName,
    required this.movementCount,
  });

  AssetMovementByAssetStatsModel copyWith({
    String? assetID,
    String? assetTag,
    String? assetName,
    int? movementCount,
  }) {
    return AssetMovementByAssetStatsModel(
      assetID: assetID ?? this.assetID,
      assetTag: assetTag ?? this.assetTag,
      assetName: assetName ?? this.assetName,
      movementCount: movementCount ?? this.movementCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetID,
      'assetTag': assetTag,
      'assetName': assetName,
      'movementCount': movementCount,
    };
  }

  factory AssetMovementByAssetStatsModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementByAssetStatsModel(
      assetID: map['assetId'] as String,
      assetTag: map['assetTag'] as String,
      assetName: map['assetName'] as String,
      movementCount: map['movementCount'] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementByAssetStatsModel.fromJson(String source) =>
      AssetMovementByAssetStatsModel.fromMap(jsonDecode(source));
}

class AssetMovementByLocationStatsModel {
  final String locationID;
  final String locationCode;
  final String locationName;
  final int incomingCount;
  final int outgoingCount;
  final int netMovement;

  const AssetMovementByLocationStatsModel({
    required this.locationID,
    required this.locationCode,
    required this.locationName,
    required this.incomingCount,
    required this.outgoingCount,
    required this.netMovement,
  });

  AssetMovementByLocationStatsModel copyWith({
    String? locationID,
    String? locationCode,
    String? locationName,
    int? incomingCount,
    int? outgoingCount,
    int? netMovement,
  }) {
    return AssetMovementByLocationStatsModel(
      locationID: locationID ?? this.locationID,
      locationCode: locationCode ?? this.locationCode,
      locationName: locationName ?? this.locationName,
      incomingCount: incomingCount ?? this.incomingCount,
      outgoingCount: outgoingCount ?? this.outgoingCount,
      netMovement: netMovement ?? this.netMovement,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locationId': locationID,
      'locationCode': locationCode,
      'locationName': locationName,
      'incomingCount': incomingCount,
      'outgoingCount': outgoingCount,
      'netMovement': netMovement,
    };
  }

  factory AssetMovementByLocationStatsModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementByLocationStatsModel(
      locationID: map['locationId'] as String,
      locationCode: map['locationCode'] as String,
      locationName: map['locationName'] as String,
      incomingCount: map['incomingCount'] as int,
      outgoingCount: map['outgoingCount'] as int,
      netMovement: map['netMovement'] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementByLocationStatsModel.fromJson(String source) =>
      AssetMovementByLocationStatsModel.fromMap(jsonDecode(source));
}

class AssetMovementByUserStatsModel {
  final String userID;
  final String userName;
  final int movementCount;

  const AssetMovementByUserStatsModel({
    required this.userID,
    required this.userName,
    required this.movementCount,
  });

  AssetMovementByUserStatsModel copyWith({
    String? userID,
    String? userName,
    int? movementCount,
  }) {
    return AssetMovementByUserStatsModel(
      userID: userID ?? this.userID,
      userName: userName ?? this.userName,
      movementCount: movementCount ?? this.movementCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userID,
      'userName': userName,
      'movementCount': movementCount,
    };
  }

  factory AssetMovementByUserStatsModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementByUserStatsModel(
      userID: map['userId'] as String,
      userName: map['userName'] as String,
      movementCount: map['movementCount'] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementByUserStatsModel.fromJson(String source) =>
      AssetMovementByUserStatsModel.fromMap(jsonDecode(source));
}

class AssetMovementTypeStatisticsModel {
  final int locationToLocation;
  final int locationToUser;
  final int userToLocation;
  final int userToUser;
  final int newAsset;

  const AssetMovementTypeStatisticsModel({
    required this.locationToLocation,
    required this.locationToUser,
    required this.userToLocation,
    required this.userToUser,
    required this.newAsset,
  });

  AssetMovementTypeStatisticsModel copyWith({
    int? locationToLocation,
    int? locationToUser,
    int? userToLocation,
    int? userToUser,
    int? newAsset,
  }) {
    return AssetMovementTypeStatisticsModel(
      locationToLocation: locationToLocation ?? this.locationToLocation,
      locationToUser: locationToUser ?? this.locationToUser,
      userToLocation: userToLocation ?? this.userToLocation,
      userToUser: userToUser ?? this.userToUser,
      newAsset: newAsset ?? this.newAsset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'locationToLocation': locationToLocation,
      'locationToUser': locationToUser,
      'userToLocation': userToLocation,
      'userToUser': userToUser,
      'newAsset': newAsset,
    };
  }

  factory AssetMovementTypeStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementTypeStatisticsModel(
      locationToLocation: map['locationToLocation'] as int,
      locationToUser: map['locationToUser'] as int,
      userToLocation: map['userToLocation'] as int,
      userToUser: map['userToUser'] as int,
      newAsset: map['newAsset'] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementTypeStatisticsModel.fromJson(String source) =>
      AssetMovementTypeStatisticsModel.fromMap(jsonDecode(source));
}

class AssetMovementRecentStatsModel {
  final String id;
  final String assetTag;
  final String assetName;
  final String? fromLocation;
  final String? toLocation;
  final String? fromUser;
  final String? toUser;
  final String movedBy;
  final DateTime movementDate;
  final String movementType;

  const AssetMovementRecentStatsModel({
    required this.id,
    required this.assetTag,
    required this.assetName,
    this.fromLocation,
    this.toLocation,
    this.fromUser,
    this.toUser,
    required this.movedBy,
    required this.movementDate,
    required this.movementType,
  });

  AssetMovementRecentStatsModel copyWith({
    String? id,
    String? assetTag,
    String? assetName,
    String? fromLocation,
    String? toLocation,
    String? fromUser,
    String? toUser,
    String? movedBy,
    DateTime? movementDate,
    String? movementType,
  }) {
    return AssetMovementRecentStatsModel(
      id: id ?? this.id,
      assetTag: assetTag ?? this.assetTag,
      assetName: assetName ?? this.assetName,
      fromLocation: fromLocation ?? this.fromLocation,
      toLocation: toLocation ?? this.toLocation,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
      movedBy: movedBy ?? this.movedBy,
      movementDate: movementDate ?? this.movementDate,
      movementType: movementType ?? this.movementType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetTag': assetTag,
      'assetName': assetName,
      'fromLocation': fromLocation,
      'toLocation': toLocation,
      'fromUser': fromUser,
      'toUser': toUser,
      'movedBy': movedBy,
      'movementDate': movementDate.toIso8601String(),
      'movementType': movementType,
    };
  }

  factory AssetMovementRecentStatsModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementRecentStatsModel(
      id: map['id'] as String,
      assetTag: map['assetTag'] as String,
      assetName: map['assetName'] as String,
      fromLocation: map['fromLocation'] as String?,
      toLocation: map['toLocation'] as String?,
      fromUser: map['fromUser'] as String?,
      toUser: map['toUser'] as String?,
      movedBy: map['movedBy'] as String,
      movementDate: DateTime.parse(map['movementDate'] as String),
      movementType: map['movementType'] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementRecentStatsModel.fromJson(String source) =>
      AssetMovementRecentStatsModel.fromMap(jsonDecode(source));
}

class AssetMovementTrendModel {
  final String date;
  final int count;

  const AssetMovementTrendModel({required this.date, required this.count});

  AssetMovementTrendModel copyWith({String? date, int? count}) {
    return AssetMovementTrendModel(
      date: date ?? this.date,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date, 'count': count};
  }

  factory AssetMovementTrendModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementTrendModel(
      date: map['date'] as String,
      count: map['count'] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementTrendModel.fromJson(String source) =>
      AssetMovementTrendModel.fromMap(jsonDecode(source));
}

class AssetMovementSummaryStatisticsModel {
  final int totalMovements;
  final int movementsToday;
  final int movementsThisWeek;
  final int movementsThisMonth;
  final String mostActiveAsset;
  final String mostActiveLocation;
  final String mostActiveUser;
  final double averageMovementsPerDay;
  final double averageMovementsPerAsset;
  final DateTime latestMovementDate;
  final DateTime earliestMovementDate;
  final int uniqueAssetsWithMovements;
  final int uniqueLocationsInvolved;
  final int uniqueUsersInvolved;

  const AssetMovementSummaryStatisticsModel({
    required this.totalMovements,
    required this.movementsToday,
    required this.movementsThisWeek,
    required this.movementsThisMonth,
    required this.mostActiveAsset,
    required this.mostActiveLocation,
    required this.mostActiveUser,
    required this.averageMovementsPerDay,
    required this.averageMovementsPerAsset,
    required this.latestMovementDate,
    required this.earliestMovementDate,
    required this.uniqueAssetsWithMovements,
    required this.uniqueLocationsInvolved,
    required this.uniqueUsersInvolved,
  });

  AssetMovementSummaryStatisticsModel copyWith({
    int? totalMovements,
    int? movementsToday,
    int? movementsThisWeek,
    int? movementsThisMonth,
    String? mostActiveAsset,
    String? mostActiveLocation,
    String? mostActiveUser,
    double? averageMovementsPerDay,
    double? averageMovementsPerAsset,
    DateTime? latestMovementDate,
    DateTime? earliestMovementDate,
    int? uniqueAssetsWithMovements,
    int? uniqueLocationsInvolved,
    int? uniqueUsersInvolved,
  }) {
    return AssetMovementSummaryStatisticsModel(
      totalMovements: totalMovements ?? this.totalMovements,
      movementsToday: movementsToday ?? this.movementsToday,
      movementsThisWeek: movementsThisWeek ?? this.movementsThisWeek,
      movementsThisMonth: movementsThisMonth ?? this.movementsThisMonth,
      mostActiveAsset: mostActiveAsset ?? this.mostActiveAsset,
      mostActiveLocation: mostActiveLocation ?? this.mostActiveLocation,
      mostActiveUser: mostActiveUser ?? this.mostActiveUser,
      averageMovementsPerDay:
          averageMovementsPerDay ?? this.averageMovementsPerDay,
      averageMovementsPerAsset:
          averageMovementsPerAsset ?? this.averageMovementsPerAsset,
      latestMovementDate: latestMovementDate ?? this.latestMovementDate,
      earliestMovementDate: earliestMovementDate ?? this.earliestMovementDate,
      uniqueAssetsWithMovements:
          uniqueAssetsWithMovements ?? this.uniqueAssetsWithMovements,
      uniqueLocationsInvolved:
          uniqueLocationsInvolved ?? this.uniqueLocationsInvolved,
      uniqueUsersInvolved: uniqueUsersInvolved ?? this.uniqueUsersInvolved,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalMovements': totalMovements,
      'movementsToday': movementsToday,
      'movementsThisWeek': movementsThisWeek,
      'movementsThisMonth': movementsThisMonth,
      'mostActiveAsset': mostActiveAsset,
      'mostActiveLocation': mostActiveLocation,
      'mostActiveUser': mostActiveUser,
      'averageMovementsPerDay': averageMovementsPerDay,
      'averageMovementsPerAsset': averageMovementsPerAsset,
      'latestMovementDate': latestMovementDate.toIso8601String(),
      'earliestMovementDate': earliestMovementDate.toIso8601String(),
      'uniqueAssetsWithMovements': uniqueAssetsWithMovements,
      'uniqueLocationsInvolved': uniqueLocationsInvolved,
      'uniqueUsersInvolved': uniqueUsersInvolved,
    };
  }

  factory AssetMovementSummaryStatisticsModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return AssetMovementSummaryStatisticsModel(
      totalMovements: map['totalMovements'] as int,
      movementsToday: map['movementsToday'] as int,
      movementsThisWeek: map['movementsThisWeek'] as int,
      movementsThisMonth: map['movementsThisMonth'] as int,
      mostActiveAsset: map['mostActiveAsset'] as String,
      mostActiveLocation: map['mostActiveLocation'] as String,
      mostActiveUser: map['mostActiveUser'] as String,
      averageMovementsPerDay: map['averageMovementsPerDay'] as double,
      averageMovementsPerAsset: map['averageMovementsPerAsset'] as double,
      latestMovementDate: DateTime.parse(map['latestMovementDate'] as String),
      earliestMovementDate: DateTime.parse(
        map['earliestMovementDate'] as String,
      ),
      uniqueAssetsWithMovements: map['uniqueAssetsWithMovements'] as int,
      uniqueLocationsInvolved: map['uniqueLocationsInvolved'] as int,
      uniqueUsersInvolved: map['uniqueUsersInvolved'] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementSummaryStatisticsModel.fromJson(String source) =>
      AssetMovementSummaryStatisticsModel.fromMap(jsonDecode(source));
}

class AssetMovementStatisticsModel {
  final AssetMovementCountStatisticsModel total;
  final List<AssetMovementByAssetStatsModel> byAsset;
  final List<AssetMovementByLocationStatsModel> byLocation;
  final List<AssetMovementByUserStatsModel> byUser;
  final AssetMovementTypeStatisticsModel byMovementType;
  final List<AssetMovementRecentStatsModel> recentMovements;
  final List<AssetMovementTrendModel> movementTrends;
  final AssetMovementSummaryStatisticsModel summary;

  const AssetMovementStatisticsModel({
    required this.total,
    required this.byAsset,
    required this.byLocation,
    required this.byUser,
    required this.byMovementType,
    required this.recentMovements,
    required this.movementTrends,
    required this.summary,
  });

  AssetMovementStatisticsModel copyWith({
    AssetMovementCountStatisticsModel? total,
    List<AssetMovementByAssetStatsModel>? byAsset,
    List<AssetMovementByLocationStatsModel>? byLocation,
    List<AssetMovementByUserStatsModel>? byUser,
    AssetMovementTypeStatisticsModel? byMovementType,
    List<AssetMovementRecentStatsModel>? recentMovements,
    List<AssetMovementTrendModel>? movementTrends,
    AssetMovementSummaryStatisticsModel? summary,
  }) {
    return AssetMovementStatisticsModel(
      total: total ?? this.total,
      byAsset: byAsset ?? this.byAsset,
      byLocation: byLocation ?? this.byLocation,
      byUser: byUser ?? this.byUser,
      byMovementType: byMovementType ?? this.byMovementType,
      recentMovements: recentMovements ?? this.recentMovements,
      movementTrends: movementTrends ?? this.movementTrends,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byAsset': byAsset.map((x) => x.toMap()).toList(),
      'byLocation': byLocation.map((x) => x.toMap()).toList(),
      'byUser': byUser.map((x) => x.toMap()).toList(),
      'byMovementType': byMovementType.toMap(),
      'recentMovements': recentMovements.map((x) => x.toMap()).toList(),
      'movementTrends': movementTrends.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory AssetMovementStatisticsModel.fromMap(Map<String, dynamic> map) {
    return AssetMovementStatisticsModel(
      total: AssetMovementCountStatisticsModel.fromMap(
        map['total'] as Map<String, dynamic>,
      ),
      byAsset: List<AssetMovementByAssetStatsModel>.from(
        (map['byAsset'] as List<dynamic>).map<AssetMovementByAssetStatsModel>(
          (x) =>
              AssetMovementByAssetStatsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      byLocation: List<AssetMovementByLocationStatsModel>.from(
        (map['byLocation'] as List<dynamic>)
            .map<AssetMovementByLocationStatsModel>(
              (x) => AssetMovementByLocationStatsModel.fromMap(
                x as Map<String, dynamic>,
              ),
            ),
      ),
      byUser: List<AssetMovementByUserStatsModel>.from(
        (map['byUser'] as List<dynamic>).map<AssetMovementByUserStatsModel>(
          (x) =>
              AssetMovementByUserStatsModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      byMovementType: AssetMovementTypeStatisticsModel.fromMap(
        map['byMovementType'] as Map<String, dynamic>,
      ),
      recentMovements: List<AssetMovementRecentStatsModel>.from(
        (map['recentMovements'] as List<dynamic>)
            .map<AssetMovementRecentStatsModel>(
              (x) => AssetMovementRecentStatsModel.fromMap(
                x as Map<String, dynamic>,
              ),
            ),
      ),
      movementTrends: List<AssetMovementTrendModel>.from(
        (map['movementTrends'] as List<dynamic>).map<AssetMovementTrendModel>(
          (x) => AssetMovementTrendModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      summary: AssetMovementSummaryStatisticsModel.fromMap(
        map['summary'] as Map<String, dynamic>,
      ),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory AssetMovementStatisticsModel.fromJson(String source) =>
      AssetMovementStatisticsModel.fromMap(jsonDecode(source));
}
