import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class LocationStatisticsModel extends Equatable {
  final LocationCountStatisticsModel total;
  final List<BuildingStatisticsModel> byBuilding;
  final List<FloorStatisticsModel> byFloor;
  final GeographicStatisticsModel geographic;
  final List<LocationCreationTrendModel> creationTrends;
  final LocationSummaryStatisticsModel summary;

  const LocationStatisticsModel({
    required this.total,
    required this.byBuilding,
    required this.byFloor,
    required this.geographic,
    required this.creationTrends,
    required this.summary,
  });

  @override
  List<Object> get props => [
    total,
    byBuilding,
    byFloor,
    geographic,
    creationTrends,
    summary,
  ];

  LocationStatisticsModel copyWith({
    LocationCountStatisticsModel? total,
    List<BuildingStatisticsModel>? byBuilding,
    List<FloorStatisticsModel>? byFloor,
    GeographicStatisticsModel? geographic,
    List<LocationCreationTrendModel>? creationTrends,
    LocationSummaryStatisticsModel? summary,
  }) {
    return LocationStatisticsModel(
      total: total ?? this.total,
      byBuilding: byBuilding ?? this.byBuilding,
      byFloor: byFloor ?? this.byFloor,
      geographic: geographic ?? this.geographic,
      creationTrends: creationTrends ?? this.creationTrends,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byBuilding': byBuilding.map((x) => x.toMap()).toList(),
      'byFloor': byFloor.map((x) => x.toMap()).toList(),
      'geographic': geographic.toMap(),
      'creationTrends': creationTrends.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory LocationStatisticsModel.fromMap(Map<String, dynamic> map) {
    return LocationStatisticsModel(
      total: LocationCountStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('total'),
      ),
      byBuilding: List<BuildingStatisticsModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('byBuilding')
                ?.map(
                  (x) => BuildingStatisticsModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
      byFloor: List<FloorStatisticsModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('byFloor')
                ?.map(
                  (x) =>
                      FloorStatisticsModel.fromMap(x as Map<String, dynamic>),
                ) ??
            [],
      ),
      geographic: GeographicStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('geographic'),
      ),
      creationTrends: List<LocationCreationTrendModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('creationTrends')
                ?.map(
                  (x) => LocationCreationTrendModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
      summary: LocationSummaryStatisticsModel.fromMap(
        map.getField<Map<String, dynamic>>('summary'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationStatisticsModel.fromJson(String source) =>
      LocationStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LocationStatisticsModel(total: $total, byBuilding: $byBuilding, byFloor: $byFloor, geographic: $geographic, creationTrends: $creationTrends, summary: $summary)';
  }
}

class LocationCountStatisticsModel extends Equatable {
  final int count;

  const LocationCountStatisticsModel({required this.count});

  @override
  List<Object> get props => [count];

  LocationCountStatisticsModel copyWith({int? count}) {
    return LocationCountStatisticsModel(count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory LocationCountStatisticsModel.fromMap(Map<String, dynamic> map) {
    return LocationCountStatisticsModel(
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationCountStatisticsModel.fromJson(String source) =>
      LocationCountStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() => 'LocationCountStatisticsModel(count: $count)';
}

class BuildingStatisticsModel extends Equatable {
  final String building;
  final int count;

  const BuildingStatisticsModel({required this.building, required this.count});

  @override
  List<Object> get props => [building, count];

  BuildingStatisticsModel copyWith({String? building, int? count}) {
    return BuildingStatisticsModel(
      building: building ?? this.building,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'building': building, 'count': count};
  }

  factory BuildingStatisticsModel.fromMap(Map<String, dynamic> map) {
    return BuildingStatisticsModel(
      building: map.getFieldOrNull<String>('building') ?? '',
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BuildingStatisticsModel.fromJson(String source) =>
      BuildingStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'BuildingStatisticsModel(building: $building, count: $count)';
}

class FloorStatisticsModel extends Equatable {
  final String floor;
  final int count;

  const FloorStatisticsModel({required this.floor, required this.count});

  @override
  List<Object> get props => [floor, count];

  FloorStatisticsModel copyWith({String? floor, int? count}) {
    return FloorStatisticsModel(
      floor: floor ?? this.floor,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'floor': floor, 'count': count};
  }

  factory FloorStatisticsModel.fromMap(Map<String, dynamic> map) {
    return FloorStatisticsModel(
      floor: map.getFieldOrNull<String>('floor') ?? '',
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FloorStatisticsModel.fromJson(String source) =>
      FloorStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() => 'FloorStatisticsModel(floor: $floor, count: $count)';
}

class GeographicStatisticsModel extends Equatable {
  final int withCoordinates;
  final int withoutCoordinates;
  final double? averageLatitude;
  final double? averageLongitude;

  const GeographicStatisticsModel({
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

  GeographicStatisticsModel copyWith({
    int? withCoordinates,
    int? withoutCoordinates,
    double? averageLatitude,
    double? averageLongitude,
  }) {
    return GeographicStatisticsModel(
      withCoordinates: withCoordinates ?? this.withCoordinates,
      withoutCoordinates: withoutCoordinates ?? this.withoutCoordinates,
      averageLatitude: averageLatitude ?? this.averageLatitude,
      averageLongitude: averageLongitude ?? this.averageLongitude,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'withCoordinates': withCoordinates,
      'withoutCoordinates': withoutCoordinates,
      'averageLatitude': averageLatitude,
      'averageLongitude': averageLongitude,
    };
  }

  factory GeographicStatisticsModel.fromMap(Map<String, dynamic> map) {
    return GeographicStatisticsModel(
      withCoordinates: map.getFieldOrNull<int>('withCoordinates') ?? 0,
      withoutCoordinates: map.getFieldOrNull<int>('withoutCoordinates') ?? 0,
      averageLatitude: map.getDoubleOrNull('averageLatitude'),
      averageLongitude: map.getDoubleOrNull('averageLongitude'),
    );
  }

  String toJson() => json.encode(toMap());

  factory GeographicStatisticsModel.fromJson(String source) =>
      GeographicStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'GeographicStatisticsModel(withCoordinates: $withCoordinates, withoutCoordinates: $withoutCoordinates, averageLatitude: $averageLatitude, averageLongitude: $averageLongitude)';
}

class LocationCreationTrendModel extends Equatable {
  final DateTime date;
  final int count;

  const LocationCreationTrendModel({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];

  LocationCreationTrendModel copyWith({DateTime? date, int? count}) {
    return LocationCreationTrendModel(
      date: date ?? this.date,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'date': date.toIso8601String(), 'count': count};
  }

  factory LocationCreationTrendModel.fromMap(Map<String, dynamic> map) {
    return LocationCreationTrendModel(
      date: map.getDateTime('date'),
      count: map.getFieldOrNull<int>('count') ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationCreationTrendModel.fromJson(String source) =>
      LocationCreationTrendModel.fromMap(json.decode(source));

  @override
  String toString() => 'LocationCreationTrendModel(date: $date, count: $count)';
}

class LocationSummaryStatisticsModel extends Equatable {
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
  final String latestCreationDate;
  final String earliestCreationDate;

  const LocationSummaryStatisticsModel({
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

  LocationSummaryStatisticsModel copyWith({
    int? totalLocations,
    int? locationsWithBuilding,
    int? locationsWithoutBuilding,
    int? locationsWithFloor,
    int? locationsWithoutFloor,
    int? locationsWithCoordinates,
    double? coordinatesPercentage,
    double? buildingPercentage,
    double? floorPercentage,
    int? totalBuildings,
    int? totalFloors,
    double? averageLocationsPerDay,
    String? latestCreationDate,
    String? earliestCreationDate,
  }) {
    return LocationSummaryStatisticsModel(
      totalLocations: totalLocations ?? this.totalLocations,
      locationsWithBuilding:
          locationsWithBuilding ?? this.locationsWithBuilding,
      locationsWithoutBuilding:
          locationsWithoutBuilding ?? this.locationsWithoutBuilding,
      locationsWithFloor: locationsWithFloor ?? this.locationsWithFloor,
      locationsWithoutFloor:
          locationsWithoutFloor ?? this.locationsWithoutFloor,
      locationsWithCoordinates:
          locationsWithCoordinates ?? this.locationsWithCoordinates,
      coordinatesPercentage:
          coordinatesPercentage ?? this.coordinatesPercentage,
      buildingPercentage: buildingPercentage ?? this.buildingPercentage,
      floorPercentage: floorPercentage ?? this.floorPercentage,
      totalBuildings: totalBuildings ?? this.totalBuildings,
      totalFloors: totalFloors ?? this.totalFloors,
      averageLocationsPerDay:
          averageLocationsPerDay ?? this.averageLocationsPerDay,
      latestCreationDate: latestCreationDate ?? this.latestCreationDate,
      earliestCreationDate: earliestCreationDate ?? this.earliestCreationDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalLocations': totalLocations,
      'locationsWithBuilding': locationsWithBuilding,
      'locationsWithoutBuilding': locationsWithoutBuilding,
      'locationsWithFloor': locationsWithFloor,
      'locationsWithoutFloor': locationsWithoutFloor,
      'locationsWithCoordinates': locationsWithCoordinates,
      'coordinatesPercentage': coordinatesPercentage,
      'buildingPercentage': buildingPercentage,
      'floorPercentage': floorPercentage,
      'totalBuildings': totalBuildings,
      'totalFloors': totalFloors,
      'averageLocationsPerDay': averageLocationsPerDay,
      'latestCreationDate': latestCreationDate,
      'earliestCreationDate': earliestCreationDate,
    };
  }

  factory LocationSummaryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return LocationSummaryStatisticsModel(
      totalLocations: map.getFieldOrNull<int>('totalLocations') ?? 0,
      locationsWithBuilding:
          map.getFieldOrNull<int>('locationsWithBuilding') ?? 0,
      locationsWithoutBuilding:
          map.getFieldOrNull<int>('locationsWithoutBuilding') ?? 0,
      locationsWithFloor: map.getFieldOrNull<int>('locationsWithFloor') ?? 0,
      locationsWithoutFloor:
          map.getFieldOrNull<int>('locationsWithoutFloor') ?? 0,
      locationsWithCoordinates:
          map.getFieldOrNull<int>('locationsWithCoordinates') ?? 0,
      coordinatesPercentage:
          map.getDoubleOrNull('coordinatesPercentage') ?? 0.0,
      buildingPercentage: map.getDoubleOrNull('buildingPercentage') ?? 0.0,
      floorPercentage: map.getDoubleOrNull('floorPercentage') ?? 0.0,
      totalBuildings: map.getFieldOrNull<int>('totalBuildings') ?? 0,
      totalFloors: map.getFieldOrNull<int>('totalFloors') ?? 0,
      averageLocationsPerDay:
          map.getDoubleOrNull('averageLocationsPerDay') ?? 0.0,
      latestCreationDate:
          map.getFieldOrNull<String>('latestCreationDate') ?? '',
      earliestCreationDate:
          map.getFieldOrNull<String>('earliestCreationDate') ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationSummaryStatisticsModel.fromJson(String source) =>
      LocationSummaryStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LocationSummaryStatisticsModel(totalLocations: $totalLocations, locationsWithBuilding: $locationsWithBuilding, locationsWithoutBuilding: $locationsWithoutBuilding, locationsWithFloor: $locationsWithFloor, locationsWithoutFloor: $locationsWithoutFloor, locationsWithCoordinates: $locationsWithCoordinates, coordinatesPercentage: $coordinatesPercentage, buildingPercentage: $buildingPercentage, floorPercentage: $floorPercentage, totalBuildings: $totalBuildings, totalFloors: $totalFloors, averageLocationsPerDay: $averageLocationsPerDay, latestCreationDate: $latestCreationDate, earliestCreationDate: $earliestCreationDate)';
  }
}
