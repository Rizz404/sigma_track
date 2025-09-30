import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class CheckLocationExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckLocationExistsUsecaseParams> {
  final LocationRepository _locationRepository;

  CheckLocationExistsUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckLocationExistsUsecaseParams params,
  ) async {
    return await _locationRepository.checkLocationExists(params);
  }
}

class CheckLocationExistsUsecaseParams extends Equatable {
  final String id;

  CheckLocationExistsUsecaseParams({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory CheckLocationExistsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CheckLocationExistsUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CheckLocationExistsUsecaseParams.fromJson(String source) =>
      CheckLocationExistsUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object> get props => [id];
}
