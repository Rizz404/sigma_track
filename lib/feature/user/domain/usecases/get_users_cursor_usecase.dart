import 'dart:convert';

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
    String? search,
    String? role,
    bool? isActive,
    String? employeeId,
    UserSortBy? sortBy,
    SortOrder? sortOrder,
    int? limit,
    String? cursor,
  }) {
    return GetUsersCursorUsecaseParams(
      search: search ?? this.search,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      employeeId: employeeId ?? this.employeeId,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      limit: limit ?? this.limit,
      cursor: cursor ?? this.cursor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'search': search,
      'role': role,
      'isActive': isActive,
      'employeeId': employeeId,
      'sortBy': sortBy?.toMap(),
      'sortOrder': sortOrder?.toMap(),
      'limit': limit,
      'cursor': cursor,
    };
  }

  factory GetUsersCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetUsersCursorUsecaseParams(
      search: map['search'],
      role: map['role'],
      isActive: map['isActive'],
      employeeId: map['employeeId'],
      sortBy: map['sortBy'] != null ? UserSortBy.fromMap(map['sortBy']) : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.fromMap(map['sortOrder'])
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
