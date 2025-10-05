import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String id;
  final String locationName;
  final String locationCode;
  final String? building;
  final String? floor;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<LocationTranslation>? translations;

  const Location({
    required this.id,
    required this.locationName,
    required this.locationCode,
    this.building,
    this.floor,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
    this.translations,
  });

  factory Location.dummy() => Location(
    id: '',
    locationName: '',
    locationCode: '',
    createdAt: DateTime(0),
    updatedAt: DateTime(0),
  );

  @override
  List<Object?> get props {
    return [
      id,
      locationName,
      locationCode,
      building,
      floor,
      latitude,
      longitude,
      createdAt,
      updatedAt,
      translations,
    ];
  }
}

class LocationTranslation extends Equatable {
  final String langCode;
  final String locationName;

  const LocationTranslation({
    required this.langCode,
    required this.locationName,
  });

  @override
  List<Object> get props => [langCode, locationName];
}
