import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class ExportUserListUsecase
    implements Usecase<ItemSuccess<Uint8List>, ExportUserListUsecaseParams> {
  final UserRepository _userRepository;

  ExportUserListUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> call(
    ExportUserListUsecaseParams params,
  ) async {
    return await _userRepository.exportUserList(params);
  }
}

class ExportUserListUsecaseParams extends Equatable {
  final ExportFormat format;
  final String? searchQuery;
  final UserRole? role;
  final bool? isActive;
  final String? department;
  final UserSortBy? sortBy;
  final SortOrder? sortOrder;

  const ExportUserListUsecaseParams({
    required this.format,
    this.searchQuery,
    this.role,
    this.isActive,
    this.department,
    this.sortBy,
    this.sortOrder,
  });

  ExportUserListUsecaseParams copyWith({
    ExportFormat? format,
    String? searchQuery,
    UserRole? role,
    bool? isActive,
    String? department,
    UserSortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return ExportUserListUsecaseParams(
      format: format ?? this.format,
      searchQuery: searchQuery ?? this.searchQuery,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      department: department ?? this.department,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'format': format.value,
      if (searchQuery != null) 'searchQuery': searchQuery,
      if (role != null) 'role': role!.value,
      if (isActive != null) 'isActive': isActive,
      if (department != null) 'department': department,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
    };
  }

  factory ExportUserListUsecaseParams.fromMap(Map<String, dynamic> map) {
    return ExportUserListUsecaseParams(
      format: ExportFormat.values.firstWhere((e) => e.value == map['format']),
      searchQuery: map['searchQuery'],
      role: map['role'] != null
          ? UserRole.values.firstWhere((e) => e.value == map['role'])
          : null,
      isActive: map['isActive'],
      department: map['department'],
      sortBy: map['sortBy'] != null
          ? UserSortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExportUserListUsecaseParams.fromJson(String source) =>
      ExportUserListUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'ExportUserListUsecaseParams(format: $format, searchQuery: $searchQuery, role: $role, isActive: $isActive, department: $department, sortBy: $sortBy, sortOrder: $sortOrder)';

  @override
  List<Object?> get props => [
    format,
    searchQuery,
    role,
    isActive,
    department,
    sortBy,
    sortOrder,
  ];
}
