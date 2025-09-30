import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class CreateLocationUsecase
    implements Usecase<ItemSuccess<Location>, CreateLocationUsecaseParams> {
  final LocationRepository _locationRepository;

  CreateLocationUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<Location>>> call(
    CreateLocationUsecaseParams params,
  ) async {
    return await _locationRepository.createLocation(params);
  }
}

class CreateLocationUsecaseParams extends Equatable {
  final String locationCode;
  final String? building;
  final String? floor;
  final double? latitude;
  final double? longitude;
  final List<CreateLocationTranslation> translations;

  CreateLocationUsecaseParams({
    required this.locationCode,
    this.building,
    this.floor,
    this.latitude,
    this.longitude,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'locationCode': locationCode,
      'building': building,
      'floor': floor,
      'latitude': latitude,
      'longitude': longitude,
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateLocationUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CreateLocationUsecaseParams(
      locationCode: map['locationCode'] ?? '',
      building: map['building'],
      floor: map['floor'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      translations: List<CreateLocationTranslation>.from(
        map['translations']?.map((x) => CreateLocationTranslation.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateLocationUsecaseParams.fromJson(String source) =>
      CreateLocationUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    locationCode,
    building,
    floor,
    latitude,
    longitude,
    translations,
  ];
}

class CreateLocationTranslation extends Equatable {
  final String langCode;
  final String locationName;

  CreateLocationTranslation({
    required this.langCode,
    required this.locationName,
  });

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'locationName': locationName};
  }

  factory CreateLocationTranslation.fromMap(Map<String, dynamic> map) {
    return CreateLocationTranslation(
      langCode: map['langCode'] ?? '',
      locationName: map['locationName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateLocationTranslation.fromJson(String source) =>
      CreateLocationTranslation.fromMap(json.decode(source));

  @override
  List<Object> get props => [langCode, locationName];
}
