import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class LocationModel extends Equatable {
  final String id;
  final String locationName;
  final String locationCode;
  final String? building;
  final String? floor;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<LocationTranslationModel>? translations;

  const LocationModel({
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

  LocationModel copyWith({
    String? id,
    String? locationName,
    String? locationCode,
    ValueGetter<String?>? building,
    ValueGetter<String?>? floor,
    ValueGetter<double?>? latitude,
    ValueGetter<double?>? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
    ValueGetter<List<LocationTranslationModel>?>? translations,
  }) {
    return LocationModel(
      id: id ?? this.id,
      locationName: locationName ?? this.locationName,
      locationCode: locationCode ?? this.locationCode,
      building: building != null ? building() : this.building,
      floor: floor != null ? floor() : this.floor,
      latitude: latitude != null ? latitude() : this.latitude,
      longitude: longitude != null ? longitude() : this.longitude,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translations: translations != null ? translations() : this.translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'locationName': locationName,
      'locationCode': locationCode,
      'building': building,
      'floor': floor,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'translations': translations?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map.getField<String>('id'),
      locationName: map.getField<String>('locationName'),
      locationCode: map.getField<String>('locationCode'),
      building: map.getFieldOrNull<String>('building'),
      floor: map.getFieldOrNull<String>('floor'),
      latitude: map.getFieldOrNull<double>('latitude'),
      longitude: map.getFieldOrNull<double>('longitude'),
      createdAt: map.getField<DateTime>('createdAt'),
      updatedAt: map.getField<DateTime>('updatedAt'),
      translations: List<LocationTranslationModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('translations')
                ?.map(
                  (x) => LocationTranslationModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LocationModel(id: $id, locationName: $locationName, locationCode: $locationCode, building: $building, floor: $floor, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations)';
  }
}

class LocationTranslationModel extends Equatable {
  final String langCode;
  final String locationName;

  const LocationTranslationModel({
    required this.langCode,
    required this.locationName,
  });

  @override
  List<Object> get props => [langCode, locationName];

  LocationTranslationModel copyWith({String? langCode, String? locationName}) {
    return LocationTranslationModel(
      langCode: langCode ?? this.langCode,
      locationName: locationName ?? this.locationName,
    );
  }

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'locationName': locationName};
  }

  factory LocationTranslationModel.fromMap(Map<String, dynamic> map) {
    return LocationTranslationModel(
      langCode: map.getField<String>('langCode'),
      locationName: map.getField<String>('locationName'),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationTranslationModel.fromJson(String source) =>
      LocationTranslationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LocationTranslationModel(langCode: $langCode, locationName: $locationName)';
}
