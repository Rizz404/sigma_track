import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class CheckLocationCodeExistsUsecase
    implements
        Usecase<ItemSuccess<bool>, CheckLocationCodeExistsUsecaseParams> {
  final LocationRepository _locationRepository;

  CheckLocationCodeExistsUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckLocationCodeExistsUsecaseParams params,
  ) async {
    return await _locationRepository.checkLocationCodeExists(params);
  }
}

class CheckLocationCodeExistsUsecaseParams extends Equatable {
  final String code;

  CheckLocationCodeExistsUsecaseParams({required this.code});

  Map<String, dynamic> toMap() {
    return {'code': code};
  }

  factory CheckLocationCodeExistsUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return CheckLocationCodeExistsUsecaseParams(code: map['code'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CheckLocationCodeExistsUsecaseParams.fromJson(String source) =>
      CheckLocationCodeExistsUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object> get props => [code];
}
