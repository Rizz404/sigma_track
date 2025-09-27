import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/data/models/location_model.dart';
import 'package:sigma_track/feature/location/domain/entities/location_statistics.dart';
import 'package:sigma_track/feature/location/data/models/location_statistics_model.dart';

extension LocationModelMapper on LocationModel {
  Location toEntity() {
    return Location(
      id: id,
      locationName: locationName,
      locationCode: locationCode,
      building: building,
      floor: floor,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations: translations.map((model) => model.toEntity()).toList(),
    );
  }
}

extension LocationEntityMapper on Location {
  LocationModel toModel() {
    return LocationModel(
      id: id,
      locationName: locationName,
      locationCode: locationCode,
      building: building,
      floor: floor,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations: translations.map((entity) => entity.toModel()).toList(),
    );
  }
}

extension LocationTranslationModelMapper on LocationTranslationModel {
  LocationTranslation toEntity() {
    return LocationTranslation(langCode: langCode, locationName: locationName);
  }
}

extension LocationTranslationEntityMapper on LocationTranslation {
  LocationTranslationModel toModel() {
    return LocationTranslationModel(
      langCode: langCode,
      locationName: locationName,
    );
  }
}

extension LocationStatisticsModelMapper on LocationStatisticsModel {
  LocationStatistics toEntity() {
    return LocationStatistics(
      total: total.toEntity(),
      byBuilding: byBuilding.map((model) => model.toEntity()).toList(),
      byFloor: byFloor.map((model) => model.toEntity()).toList(),
      geographic: geographic.toEntity(),
      creationTrends: creationTrends.map((model) => model.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

extension LocationStatisticsEntityMapper on LocationStatistics {
  LocationStatisticsModel toModel() {
    return LocationStatisticsModel(
      total: total.toModel(),
      byBuilding: byBuilding.map((entity) => entity.toModel()).toList(),
      byFloor: byFloor.map((entity) => entity.toModel()).toList(),
      geographic: geographic.toModel(),
      creationTrends: creationTrends.map((entity) => entity.toModel()).toList(),
      summary: summary.toModel(),
    );
  }
}

extension LocationCountStatisticsModelMapper on LocationCountStatisticsModel {
  LocationCountStatistics toEntity() => LocationCountStatistics(count: count);
}

extension LocationCountStatisticsEntityMapper on LocationCountStatistics {
  LocationCountStatisticsModel toModel() =>
      LocationCountStatisticsModel(count: count);
}

extension BuildingStatisticsModelMapper on BuildingStatisticsModel {
  BuildingStatistics toEntity() =>
      BuildingStatistics(building: building, count: count);
}

extension BuildingStatisticsEntityMapper on BuildingStatistics {
  BuildingStatisticsModel toModel() =>
      BuildingStatisticsModel(building: building, count: count);
}

extension FloorStatisticsModelMapper on FloorStatisticsModel {
  FloorStatistics toEntity() => FloorStatistics(floor: floor, count: count);
}

extension FloorStatisticsEntityMapper on FloorStatistics {
  FloorStatisticsModel toModel() =>
      FloorStatisticsModel(floor: floor, count: count);
}

extension GeographicStatisticsModelMapper on GeographicStatisticsModel {
  GeographicStatistics toEntity() => GeographicStatistics(
    withCoordinates: withCoordinates,
    withoutCoordinates: withoutCoordinates,
    averageLatitude: averageLatitude,
    averageLongitude: averageLongitude,
  );
}

extension GeographicStatisticsEntityMapper on GeographicStatistics {
  GeographicStatisticsModel toModel() => GeographicStatisticsModel(
    withCoordinates: withCoordinates,
    withoutCoordinates: withoutCoordinates,
    averageLatitude: averageLatitude,
    averageLongitude: averageLongitude,
  );
}

extension LocationCreationTrendModelMapper on LocationCreationTrendModel {
  LocationCreationTrend toEntity() =>
      LocationCreationTrend(date: DateTime.parse(date), count: count);
}

extension LocationCreationTrendEntityMapper on LocationCreationTrend {
  LocationCreationTrendModel toModel() =>
      LocationCreationTrendModel(date: date.toIso8601String(), count: count);
}

extension LocationSummaryStatisticsModelMapper
    on LocationSummaryStatisticsModel {
  LocationSummaryStatistics toEntity() => LocationSummaryStatistics(
    totalLocations: totalLocations,
    locationsWithBuilding: locationsWithBuilding,
    locationsWithoutBuilding: locationsWithoutBuilding,
    locationsWithFloor: locationsWithFloor,
    locationsWithoutFloor: locationsWithoutFloor,
    locationsWithCoordinates: locationsWithCoordinates,
    coordinatesPercentage: coordinatesPercentage,
    buildingPercentage: buildingPercentage,
    floorPercentage: floorPercentage,
    totalBuildings: totalBuildings,
    totalFloors: totalFloors,
    averageLocationsPerDay: averageLocationsPerDay,
    latestCreationDate: DateTime.parse(latestCreationDate),
    earliestCreationDate: DateTime.parse(earliestCreationDate),
  );
}

extension LocationSummaryStatisticsEntityMapper on LocationSummaryStatistics {
  LocationSummaryStatisticsModel toModel() => LocationSummaryStatisticsModel(
    totalLocations: totalLocations,
    locationsWithBuilding: locationsWithBuilding,
    locationsWithoutBuilding: locationsWithoutBuilding,
    locationsWithFloor: locationsWithFloor,
    locationsWithoutFloor: locationsWithoutFloor,
    locationsWithCoordinates: locationsWithCoordinates,
    coordinatesPercentage: coordinatesPercentage,
    buildingPercentage: buildingPercentage,
    floorPercentage: floorPercentage,
    totalBuildings: totalBuildings,
    totalFloors: totalFloors,
    averageLocationsPerDay: averageLocationsPerDay,
    latestCreationDate: latestCreationDate.toIso8601String(),
    earliestCreationDate: earliestCreationDate.toIso8601String(),
  );
}
