import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class DeleteLocationUsecase
    implements Usecase<ActionSuccess, DeleteLocationUsecaseParams> {
  final LocationRepository _locationRepository;

  DeleteLocationUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    DeleteLocationUsecaseParams params,
  ) async {
    return await _locationRepository.deleteLocation(params);
  }
}

class DeleteLocationUsecaseParams extends Equatable {
  final String id;

  DeleteLocationUsecaseParams({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory DeleteLocationUsecaseParams.fromMap(Map<String, dynamic> map) {
    return DeleteLocationUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory DeleteLocationUsecaseParams.fromJson(String source) =>
      DeleteLocationUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object> get props => [id];
}
