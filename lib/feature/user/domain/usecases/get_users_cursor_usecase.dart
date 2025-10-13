import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class GetUsersCursorUsecase
    implements
        Usecase<CursorPaginatedSuccess<User>, GetUsersCursorUsecaseParams> {
  final UserRepository _userRepository;

  GetUsersCursorUsecase(this._userRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<User>>> call(
    GetUsersCursorUsecaseParams params,
  ) async {
    return await _userRepository.getUsersCursor(params);
  }
}

class GetUsersCursorUsecaseParams extends Equatable {
  final String? search;
  final String? role;
  final bool? isActive;
  final String? employeeId;
  final UserSortBy? sortBy;
  final SortOrder? sortOrder;
  final int? limit;
  final String? cursor;

  GetUsersCursorUsecaseParams({
    this.search,
    this.role,
    this.isActive,
    this.employeeId,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.cursor,
  });

  GetUsersCursorUsecaseParams copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? role,
    ValueGetter<bool?>? isActive,
    ValueGetter<String?>? employeeId,
    ValueGetter<UserSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<int?>? limit,
    ValueGetter<String?>? cursor,
  }) {
    return GetUsersCursorUsecaseParams(
      search: search != null ? search() : this.search,
      role: role != null ? role() : this.role,
      isActive: isActive != null ? isActive() : this.isActive,
      employeeId: employeeId != null ? employeeId() : this.employeeId,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      limit: limit != null ? limit() : this.limit,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (role != null) 'role': role,
      if (isActive != null) 'isActive': isActive,
      if (employeeId != null) 'employeeId': employeeId,
      if (sortBy != null) 'sortBy': sortBy!.toString(),
      if (sortOrder != null) 'sortOrder': sortOrder!.toString(),
      if (limit != null) 'limit': limit,
      if (cursor != null) 'cursor': cursor,
    };
  }

  factory GetUsersCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetUsersCursorUsecaseParams(
      search: map['search'],
      role: map['role'],
      isActive: map['isActive'],
      employeeId: map['employeeId'],
      sortBy: map['sortBy'] != null
          ? UserSortBy.fromString(map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.fromString(map['sortOrder'])
          : null,
      limit: map['limit']?.toInt(),
      cursor: map['cursor'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetUsersCursorUsecaseParams.fromJson(String source) =>
      GetUsersCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GetUsersCursorUsecaseParams(search: $search, role: $role, isActive: $isActive, employeeId: $employeeId, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, cursor: $cursor)';
  }

  @override
  List<Object?> get props {
    return [
      search,
      role,
      isActive,
      employeeId,
      sortBy,
      sortOrder,
      limit,
      cursor,
    ];
  }
}
