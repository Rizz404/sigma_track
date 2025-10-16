import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class GetCategoriesCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<Category>,
          GetCategoriesCursorUsecaseParams
        > {
  final CategoryRepository _categoryRepository;

  GetCategoriesCursorUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<Category>>> call(
    GetCategoriesCursorUsecaseParams params,
  ) async {
    return await _categoryRepository.getCategoriesCursor(params);
  }
}

class GetCategoriesCursorUsecaseParams extends Equatable {
  final String? search;
  final String? parentId;
  final bool? hasParent;
  final CategorySortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  GetCategoriesCursorUsecaseParams({
    this.search,
    this.parentId,
    this.hasParent,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  GetCategoriesCursorUsecaseParams copyWith({
    String? search,
    String? parentId,
    bool? hasParent,
    CategorySortBy? sortBy,
    SortOrder? sortOrder,
    String? cursor,
    int? limit,
  }) {
    return GetCategoriesCursorUsecaseParams(
      search: search ?? this.search,
      parentId: parentId ?? this.parentId,
      hasParent: hasParent ?? this.hasParent,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (parentId != null) 'parentId': parentId,
      if (hasParent != null) 'hasParent': hasParent,
      if (sortBy != null) 'sortBy': sortBy!.toString(),
      if (sortOrder != null) 'sortOrder': sortOrder!.toString(),
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetCategoriesCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetCategoriesCursorUsecaseParams(
      search: map['search'],
      parentId: map['parentId'],
      hasParent: map['hasParent'],
      sortBy: map['sortBy'] != null
          ? CategorySortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetCategoriesCursorUsecaseParams.fromJson(String source) =>
      GetCategoriesCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetCategoriesCursorUsecaseParams(search: $search, parentId: $parentId, hasParent: $hasParent, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [
    search,
    parentId,
    hasParent,
    sortBy,
    sortOrder,
    cursor,
    limit,
  ];
}
