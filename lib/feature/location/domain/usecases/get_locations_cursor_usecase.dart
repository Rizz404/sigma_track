import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
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
  final String? cursor;
  final int? limit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;

  GetLocationsCursorUsecaseParams({
    this.cursor,
    this.limit,
    this.search,
    this.sortBy,
    this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    return {
      'cursor': cursor,
      'limit': limit,
      'search': search,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    };
  }

  factory GetLocationsCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetLocationsCursorUsecaseParams(
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
      search: map['search'],
      sortBy: map['sortBy'],
      sortOrder: map['sortOrder'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetLocationsCursorUsecaseParams.fromJson(String source) =>
      GetLocationsCursorUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [cursor, limit, search, sortBy, sortOrder];
}
