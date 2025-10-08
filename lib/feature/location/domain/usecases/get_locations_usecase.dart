import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
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
  final String? search;
  final LocationSortBy? sortBy;
  final SortOrder? sortOrder;
  final int? limit;
  final int? offset;

  GetLocationsUsecaseParams({
    this.search,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.offset,
  });

  GetLocationsUsecaseParams copyWith({
    ValueGetter<String?>? search,
    ValueGetter<LocationSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<int?>? limit,
    ValueGetter<int?>? offset,
  }) {
    return GetLocationsUsecaseParams(
      search: search != null ? search() : this.search,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      limit: limit != null ? limit() : this.limit,
      offset: offset != null ? offset() : this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy!.toString(),
      if (sortOrder != null) 'sortOrder': sortOrder!.toString(),
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  factory GetLocationsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetLocationsUsecaseParams(
      search: map['search'],
      sortBy: map['sortBy'] != null
          ? LocationSortBy.fromString(map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.fromString(map['sortOrder'])
          : null,
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetLocationsUsecaseParams.fromJson(String source) =>
      GetLocationsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetLocationsUsecaseParams(search: $search, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, offset: $offset)';

  @override
  List<Object?> get props => [search, sortBy, sortOrder, limit, offset];
}
