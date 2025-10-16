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

class GetUsersUsecase
    implements Usecase<OffsetPaginatedSuccess<User>, GetUsersUsecaseParams> {
  final UserRepository _userRepository;

  GetUsersUsecase(this._userRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<User>>> call(
    GetUsersUsecaseParams params,
  ) async {
    return await _userRepository.getUsers(params);
  }
}

class GetUsersUsecaseParams extends Equatable {
  final String? search;
  final String? role;
  final bool? isActive;
  final String? employeeId;
  final UserSortBy? sortBy;
  final SortOrder? sortOrder;
  final int? limit;
  final int? offset;

  GetUsersUsecaseParams({
    this.search,
    this.role,
    this.isActive,
    this.employeeId,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.offset,
  });

  GetUsersUsecaseParams copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? role,
    ValueGetter<bool?>? isActive,
    ValueGetter<String?>? employeeId,
    ValueGetter<UserSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<int?>? limit,
    ValueGetter<int?>? offset,
  }) {
    return GetUsersUsecaseParams(
      search: search != null ? search() : this.search,
      role: role != null ? role() : this.role,
      isActive: isActive != null ? isActive() : this.isActive,
      employeeId: employeeId != null ? employeeId() : this.employeeId,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      limit: limit != null ? limit() : this.limit,
      offset: offset != null ? offset() : this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (role != null) 'role': role,
      if (isActive != null) 'isActive': isActive,
      if (employeeId != null) 'employeeId': employeeId,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  factory GetUsersUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetUsersUsecaseParams(
      search: map['search'],
      role: map['role'],
      isActive: map['isActive'],
      employeeId: map['employeeId'],
      sortBy: map['sortBy'] != null
          ? UserSortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetUsersUsecaseParams.fromJson(String source) =>
      GetUsersUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GetUsersUsecaseParams(search: $search, role: $role, isActive: $isActive, employeeId: $employeeId, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, offset: $offset)';
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
      offset,
    ];
  }
}
