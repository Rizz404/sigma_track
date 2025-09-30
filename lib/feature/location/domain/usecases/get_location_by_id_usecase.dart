import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class GetLocationByIdUsecase
    implements Usecase<ItemSuccess<Location>, GetLocationByIdUsecaseParams> {
  final LocationRepository _locationRepository;

  GetLocationByIdUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<Location>>> call(
    GetLocationByIdUsecaseParams params,
  ) async {
    return await _locationRepository.getLocationById(params);
  }
}

class GetLocationByIdUsecaseParams extends Equatable {
  final String id;

  GetLocationByIdUsecaseParams({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory GetLocationByIdUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetLocationByIdUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory GetLocationByIdUsecaseParams.fromJson(String source) =>
      GetLocationByIdUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object> get props => [id];
}
