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

class GetLocationsCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<Location>,
          GetLocationsCursorUsecaseParams
        > {
  final LocationRepository _locationRepository;

  GetLocationsCursorUsecase(this._locationRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<Location>>> call(
    GetLocationsCursorUsecaseParams params,
  ) async {
    return await _locationRepository.getLocationsCursor(params);
  }
}

class GetLocationsCursorUsecaseParams extends Equatable {
  final String? search;
  final LocationSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  GetLocationsCursorUsecaseParams({
    this.search,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  GetLocationsCursorUsecaseParams copyWith({
    ValueGetter<String?>? search,
    ValueGetter<LocationSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return GetLocationsCursorUsecaseParams(
      search: search != null ? search() : this.search,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetLocationsCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetLocationsCursorUsecaseParams(
      search: map['search'],
      sortBy: map['sortBy'] != null
          ? LocationSortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetLocationsCursorUsecaseParams.fromJson(String source) =>
      GetLocationsCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetLocationsCursorUsecaseParams(search: $search, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [search, sortBy, sortOrder, cursor, limit];
}
