import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class UpdateLocationUsecase
    implements Usecase<ItemSuccess<Location>, UpdateLocationUsecaseParams> {
  final LocationRepository _locationRepository;

  UpdateLocationUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<Location>>> call(
    UpdateLocationUsecaseParams params,
  ) async {
    return await _locationRepository.updateLocation(params);
  }
}

class UpdateLocationUsecaseParams extends Equatable {
  final String id;
  final String? locationCode;
  final String? building;
  final String? floor;
  final double? latitude;
  final double? longitude;
  final List<UpdateLocationTranslation>? translations;

  UpdateLocationUsecaseParams({
    required this.id,
    this.locationCode,
    this.building,
    this.floor,
    this.latitude,
    this.longitude,
    this.translations,
  });

  UpdateLocationUsecaseParams copyWith({
    String? id,
    ValueGetter<String?>? locationCode,
    ValueGetter<String?>? building,
    ValueGetter<String?>? floor,
    ValueGetter<double?>? latitude,
    ValueGetter<double?>? longitude,
    ValueGetter<List<UpdateLocationTranslation>?>? translations,
  }) {
    return UpdateLocationUsecaseParams(
      id: id ?? this.id,
      locationCode: locationCode != null ? locationCode() : this.locationCode,
      building: building != null ? building() : this.building,
      floor: floor != null ? floor() : this.floor,
      latitude: latitude != null ? latitude() : this.latitude,
      longitude: longitude != null ? longitude() : this.longitude,
      translations: translations != null ? translations() : this.translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (locationCode != null) 'locationCode': locationCode,
      if (building != null) 'building': building,
      if (floor != null) 'floor': floor,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (translations != null)
        'translations': translations!.map((x) => x.toMap()).toList(),
    };
  }

  factory UpdateLocationUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateLocationUsecaseParams(
      id: map['id'] ?? '',
      locationCode: map['locationCode'],
      building: map['building'],
      floor: map['floor'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      translations: map['translations'] != null
          ? List<UpdateLocationTranslation>.from(
              map['translations']?.map(
                (x) => UpdateLocationTranslation.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateLocationUsecaseParams.fromJson(String source) =>
      UpdateLocationUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'UpdateLocationUsecaseParams(id: $id, locationCode: $locationCode, building: $building, floor: $floor, latitude: $latitude, longitude: $longitude, translations: $translations)';

  @override
  List<Object?> get props => [
    id,
    locationCode,
    building,
    floor,
    latitude,
    longitude,
    translations,
  ];
}

class UpdateLocationTranslation extends Equatable {
  final String? langCode;
  final String? locationName;

  UpdateLocationTranslation({
    required this.langCode,
    required this.locationName,
  });

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'locationName': locationName};
  }

  factory UpdateLocationTranslation.fromMap(Map<String, dynamic> map) {
    return UpdateLocationTranslation(
      langCode: map['langCode'],
      locationName: map['locationName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateLocationTranslation.fromJson(String source) =>
      UpdateLocationTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, locationName];

  UpdateLocationTranslation copyWith({
    ValueGetter<String?>? langCode,
    ValueGetter<String?>? locationName,
  }) {
    return UpdateLocationTranslation(
      langCode: langCode != null ? langCode() : this.langCode,
      locationName: locationName != null ? locationName() : this.locationName,
    );
  }

  @override
  String toString() =>
      'UpdateLocationTranslation(langCode: $langCode, locationName: $locationName)';
}
