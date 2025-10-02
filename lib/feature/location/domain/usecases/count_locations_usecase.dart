import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class CountLocationsUsecase
    implements Usecase<ItemSuccess<int>, CountLocationsUsecaseParams> {
  final LocationRepository _locationRepository;

  CountLocationsUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountLocationsUsecaseParams params,
  ) async {
    return await _locationRepository.countLocations(params);
  }
}

class CountLocationsUsecaseParams extends Equatable {
  final String? search;

  CountLocationsUsecaseParams({this.search});

  CountLocationsUsecaseParams copyWith({String? search}) {
    return CountLocationsUsecaseParams(search: search ?? this.search);
  }

  Map<String, dynamic> toMap() {
    return {if (search != null) 'search': search};
  }

  factory CountLocationsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CountLocationsUsecaseParams(search: map['search']);
  }

  String toJson() => json.encode(toMap());

  factory CountLocationsUsecaseParams.fromJson(String source) =>
      CountLocationsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'CountLocationsUsecaseParams(search: $search)';

  @override
  List<Object?> get props => [search];
}
