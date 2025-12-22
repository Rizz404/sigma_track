import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';
import 'package:sigma_track/feature/location/domain/usecases/create_location_usecase.dart';

class BulkCreateLocationsUsecase
    implements
        Usecase<
          ItemSuccess<BulkCreateLocationsResponse>,
          BulkCreateLocationsParams
        > {
  final LocationRepository _locationRepository;

  BulkCreateLocationsUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateLocationsResponse>>> call(
    BulkCreateLocationsParams params,
  ) async {
    return await _locationRepository.createManyLocations(params);
  }
}

class BulkCreateLocationsParams extends Equatable {
  final List<CreateLocationUsecaseParams> locations;

  const BulkCreateLocationsParams({required this.locations});

  Map<String, dynamic> toMap() {
    return {'locations': locations.map((x) => x.toMap()).toList()};
  }

  factory BulkCreateLocationsParams.fromMap(Map<String, dynamic> map) {
    return BulkCreateLocationsParams(
      locations: List<CreateLocationUsecaseParams>.from(
        (map['locations'] as List).map(
          (x) => CreateLocationUsecaseParams.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateLocationsParams.fromJson(String source) =>
      BulkCreateLocationsParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [locations];
}

class BulkCreateLocationsResponse extends Equatable {
  final List<Location> locations;

  const BulkCreateLocationsResponse({required this.locations});

  Map<String, dynamic> toMap() {
    return {'locations': locations.map((x) => _locationToMap(x)).toList()};
  }

  factory BulkCreateLocationsResponse.fromMap(Map<String, dynamic> map) {
    return BulkCreateLocationsResponse(
      locations: List<Location>.from(
        (map['locations'] as List).map(
          (x) => _locationFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateLocationsResponse.fromJson(String source) =>
      BulkCreateLocationsResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [locations];

  static Map<String, dynamic> _locationToMap(Location location) {
    return {
      'id': location.id,
      'locationCode': location.locationCode,
      'locationName': location.locationName,
      'building': location.building,
      'floor': location.floor,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'createdAt': location.createdAt.toIso8601String(),
      'updatedAt': location.updatedAt.toIso8601String(),
    };
  }

  static Location _locationFromMap(Map<String, dynamic> map) {
    return Location(
      id: map['id'] ?? '',
      locationCode: map['locationCode'] ?? '',
      locationName: map['locationName'] ?? '',
      building: map['building'],
      floor: map['floor'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
    );
  }
}
