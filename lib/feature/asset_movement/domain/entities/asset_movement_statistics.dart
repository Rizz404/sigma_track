import 'package:equatable/equatable.dart';

class AssetMovementStatistics extends Equatable {
  final AssetMovementCountStatistics total;
  final List<AssetMovementByAssetStats> byAsset;
  final List<AssetMovementByLocationStats> byLocation;
  final List<AssetMovementByUserStats> byUser;
  final AssetMovementTypeStatistics byMovementType;
  final List<AssetMovementRecentStats> recentMovements;
  final List<AssetMovementTrend> movementTrends;
  final AssetMovementSummaryStatistics summary;

  const AssetMovementStatistics({
    required this.total,
    required this.byAsset,
    required this.byLocation,
    required this.byUser,
    required this.byMovementType,
    required this.recentMovements,
    required this.movementTrends,
    required this.summary,
  });

  @override
  List<Object?> get props => [
    total,
    byAsset,
    byLocation,
    byUser,
    byMovementType,
    recentMovements,
    movementTrends,
    summary,
  ];
}

class AssetMovementCountStatistics extends Equatable {
  final int count;

  const AssetMovementCountStatistics({required this.count});

  @override
  List<Object?> get props => [count];
}

class AssetMovementByAssetStats extends Equatable {
  final String assetId;
  final String assetTag;
  final String assetName;
  final int movementCount;

  const AssetMovementByAssetStats({
    required this.assetId,
    required this.assetTag,
    required this.assetName,
    required this.movementCount,
  });

  @override
  List<Object?> get props => [assetId, assetTag, assetName, movementCount];
}

class AssetMovementByLocationStats extends Equatable {
  final String locationId;
  final String locationCode;
  final String locationName;
  final int incomingCount;
  final int outgoingCount;
  final int netMovement;

  const AssetMovementByLocationStats({
    required this.locationId,
    required this.locationCode,
    required this.locationName,
    required this.incomingCount,
    required this.outgoingCount,
    required this.netMovement,
  });

  @override
  List<Object?> get props => [
    locationId,
    locationCode,
    locationName,
    incomingCount,
    outgoingCount,
    netMovement,
  ];
}

class AssetMovementByUserStats extends Equatable {
  final String userId;
  final String userName;
  final int movementCount;

  const AssetMovementByUserStats({
    required this.userId,
    required this.userName,
    required this.movementCount,
  });

  @override
  List<Object?> get props => [userId, userName, movementCount];
}

class AssetMovementTypeStatistics extends Equatable {
  final int locationToLocation;
  final int locationToUser;
  final int userToLocation;
  final int userToUser;
  final int newAsset;

  const AssetMovementTypeStatistics({
    required this.locationToLocation,
    required this.locationToUser,
    required this.userToLocation,
    required this.userToUser,
    required this.newAsset,
  });

  @override
  List<Object?> get props => [
    locationToLocation,
    locationToUser,
    userToLocation,
    userToUser,
    newAsset,
  ];
}

class AssetMovementRecentStats extends Equatable {
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

  const AssetMovementRecentStats({
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

  @override
  List<Object?> get props => [
    id,
    assetTag,
    assetName,
    fromLocation,
    toLocation,
    fromUser,
    toUser,
    movedBy,
    movementDate,
    movementType,
  ];
}

class AssetMovementTrend extends Equatable {
  final DateTime date;
  final int count;

  const AssetMovementTrend({required this.date, required this.count});

  @override
  List<Object?> get props => [date, count];
}

class AssetMovementSummaryStatistics extends Equatable {
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

  const AssetMovementSummaryStatistics({
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

  @override
  List<Object?> get props => [
    totalMovements,
    movementsToday,
    movementsThisWeek,
    movementsThisMonth,
    mostActiveAsset,
    mostActiveLocation,
    mostActiveUser,
    averageMovementsPerDay,
    averageMovementsPerAsset,
    latestMovementDate,
    earliestMovementDate,
    uniqueAssetsWithMovements,
    uniqueLocationsInvolved,
    uniqueUsersInvolved,
  ];
}
