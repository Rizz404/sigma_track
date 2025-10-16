import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class GetCategoriesUsecase
    implements
        Usecase<OffsetPaginatedSuccess<Category>, GetCategoriesUsecaseParams> {
  final CategoryRepository _categoryRepository;

  GetCategoriesUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<Category>>> call(
    GetCategoriesUsecaseParams params,
  ) async {
    return await _categoryRepository.getCategories(params);
  }
}

class GetCategoriesUsecaseParams extends Equatable {
  final String? search;
  final String? parentId;
  final bool? hasParent;
  final CategorySortBy? sortBy;
  final SortOrder? sortOrder;
  final int? limit;
  final int? offset;

  GetCategoriesUsecaseParams({
    this.search,
    this.parentId,
    this.hasParent,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.offset,
  });

  GetCategoriesUsecaseParams copyWith({
    String? search,
    String? parentId,
    bool? hasParent,
    CategorySortBy? sortBy,
    SortOrder? sortOrder,
    int? limit,
    int? offset,
  }) {
    return GetCategoriesUsecaseParams(
      search: search ?? this.search,
      parentId: parentId ?? this.parentId,
      hasParent: hasParent ?? this.hasParent,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (parentId != null) 'parentId': parentId,
      if (hasParent != null) 'hasParent': hasParent,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  factory GetCategoriesUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetCategoriesUsecaseParams(
      search: map['search'],
      parentId: map['parentId'],
      hasParent: map['hasParent'],
      sortBy: map['sortBy'] != null
          ? CategorySortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetCategoriesUsecaseParams.fromJson(String source) =>
      GetCategoriesUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetCategoriesUsecaseParams(search: $search, parentId: $parentId, hasParent: $hasParent, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, offset: $offset)';

  @override
  List<Object?> get props => [
    search,
    parentId,
    hasParent,
    sortBy,
    sortOrder,
    limit,
    offset,
  ];
}
