import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class GetLocationsUsecase
    implements
        Usecase<OffsetPaginatedSuccess<Location>, GetLocationsUsecaseParams> {
  final LocationRepository _locationRepository;

  GetLocationsUsecase(this._locationRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<Location>>> call(
    GetLocationsUsecaseParams params,
  ) async {
    return await _locationRepository.getLocations(params);
  }
}

class GetLocationsUsecaseParams extends Equatable {
  final int? page;
  final int? limit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;

  GetLocationsUsecaseParams({
    this.page,
    this.limit,
    this.search,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'limit': limit,
      'search': search,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
  }

  factory GetLocationsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetLocationsUsecaseParams(
      page: map['page']?.toInt(),
      limit: map['limit']?.toInt(),
      search: map['search'],
      sortBy: map['sortBy'],
      sortOrder: map['sortOrder'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetLocationsUsecaseParams.fromJson(String source) =>
      GetLocationsUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [page, limit, search, sortBy, sortOrder];
}
