import 'package:equatable/equatable.dart';

class LocationStatistics extends Equatable {
  final LocationCountStatistics total;
  final List<BuildingStatistics> byBuilding;
  final List<FloorStatistics> byFloor;
  final GeographicStatistics geographic;
  final List<LocationCreationTrend> creationTrends;
  final LocationSummaryStatistics summary;

  const LocationStatistics({
    required this.total,
    required this.byBuilding,
    required this.byFloor,
    required this.geographic,
    required this.creationTrends,
    required this.summary,
  });

  factory LocationStatistics.dummy() => LocationStatistics(
    total: const LocationCountStatistics(count: 0),
    byBuilding: const [],
    byFloor: const [],
    geographic: const GeographicStatistics(
      withCoordinates: 0,
      withoutCoordinates: 0,
    ),
    creationTrends: const [],
    summary: LocationSummaryStatistics(
      totalLocations: 0,
      locationsWithBuilding: 0,
      locationsWithoutBuilding: 0,
      locationsWithFloor: 0,
      locationsWithoutFloor: 0,
      locationsWithCoordinates: 0,
      coordinatesPercentage: 0.0,
      buildingPercentage: 0.0,
      floorPercentage: 0.0,
      totalBuildings: 0,
      totalFloors: 0,
      averageLocationsPerDay: 0.0,
      latestCreationDate: DateTime(0),
      earliestCreationDate: DateTime(0),
    ),
  );

  @override
  List<Object> get props => [
    total,
    byBuilding,
    byFloor,
    geographic,
    creationTrends,
    summary,
  ];
}

class LocationCountStatistics extends Equatable {
  final int count;

  const LocationCountStatistics({required this.count});

  @override
  List<Object> get props => [count];
}

class BuildingStatistics extends Equatable {
  final String building;
  final int count;

  const BuildingStatistics({required this.building, required this.count});

  @override
  List<Object> get props => [building, count];
}

class FloorStatistics extends Equatable {
  final String floor;
  final int count;

  const FloorStatistics({required this.floor, required this.count});

  @override
  List<Object> get props => [floor, count];
}

class GeographicStatistics extends Equatable {
  final int withCoordinates;
  final int withoutCoordinates;
  final double? averageLatitude;
  final double? averageLongitude;

  const GeographicStatistics({
    required this.withCoordinates,
    required this.withoutCoordinates,
    this.averageLatitude,
    this.averageLongitude,
  });

  @override
  List<Object?> get props => [
    withCoordinates,
    withoutCoordinates,
    averageLatitude,
    averageLongitude,
  ];
}

class LocationCreationTrend extends Equatable {
  final DateTime date;
  final int count;

  const LocationCreationTrend({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];
}

class LocationSummaryStatistics extends Equatable {
  final int totalLocations;
  final int locationsWithBuilding;
  final int locationsWithoutBuilding;
  final int locationsWithFloor;
  final int locationsWithoutFloor;
  final int locationsWithCoordinates;
  final double coordinatesPercentage;
  final double buildingPercentage;
  final double floorPercentage;
  final int totalBuildings;
  final int totalFloors;
  final double averageLocationsPerDay;
  final DateTime latestCreationDate;
  final DateTime earliestCreationDate;

  const LocationSummaryStatistics({
    required this.totalLocations,
    required this.locationsWithBuilding,
    required this.locationsWithoutBuilding,
    required this.locationsWithFloor,
    required this.locationsWithoutFloor,
    required this.locationsWithCoordinates,
    required this.coordinatesPercentage,
    required this.buildingPercentage,
    required this.floorPercentage,
    required this.totalBuildings,
    required this.totalFloors,
    required this.averageLocationsPerDay,
    required this.latestCreationDate,
    required this.earliestCreationDate,
  });

  @override
  List<Object> get props => [
    totalLocations,
    locationsWithBuilding,
    locationsWithoutBuilding,
    locationsWithFloor,
    locationsWithoutFloor,
    locationsWithCoordinates,
    coordinatesPercentage,
    buildingPercentage,
    floorPercentage,
    totalBuildings,
    totalFloors,
    averageLocationsPerDay,
    latestCreationDate,
    earliestCreationDate,
  ];
}
