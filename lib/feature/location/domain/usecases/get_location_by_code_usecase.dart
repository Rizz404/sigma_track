import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class GetLocationByCodeUsecase
    implements Usecase<ItemSuccess<Location>, GetLocationByCodeUsecaseParams> {
  final LocationRepository _locationRepository;

  GetLocationByCodeUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<Location>>> call(
    GetLocationByCodeUsecaseParams params,
  ) async {
    return await _locationRepository.getLocationByCode(params);
  }
}

class GetLocationByCodeUsecaseParams extends Equatable {
  final String code;

  GetLocationByCodeUsecaseParams({required this.code});

  Map<String, dynamic> toMap() {
    return {'code': code};
  }

  factory GetLocationByCodeUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetLocationByCodeUsecaseParams(code: map['code'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory GetLocationByCodeUsecaseParams.fromJson(String source) =>
      GetLocationByCodeUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object> get props => [code];
}
