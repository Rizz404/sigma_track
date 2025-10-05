import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';

class AssetsFilter extends Equatable {
  final String? search;
  final AssetStatus? status;
  final AssetCondition? condition;
  final String? categoryId;
  final String? locationId;
  final String? assignedTo;
  final String? brand;
  final String? model;
  final AssetSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  AssetsFilter({
    this.search,
    this.status,
    this.condition,
    this.categoryId,
    this.locationId,
    this.assignedTo,
    this.brand,
    this.model,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  AssetsFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<AssetStatus?>? status,
    ValueGetter<AssetCondition?>? condition,
    ValueGetter<String?>? categoryId,
    ValueGetter<String?>? locationId,
    ValueGetter<String?>? assignedTo,
    ValueGetter<String?>? brand,
    ValueGetter<String?>? model,
    ValueGetter<AssetSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return AssetsFilter(
      search: search != null ? search() : this.search,
      status: status != null ? status() : this.status,
      condition: condition != null ? condition() : this.condition,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      locationId: locationId != null ? locationId() : this.locationId,
      assignedTo: assignedTo != null ? assignedTo() : this.assignedTo,
      brand: brand != null ? brand() : this.brand,
      model: model != null ? model() : this.model,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  @override
  List<Object?> get props {
    return [
      search,
      status,
      condition,
      categoryId,
      locationId,
      assignedTo,
      brand,
      model,
      sortBy,
      sortOrder,
      cursor,
      limit,
    ];
  }

  @override
  String toString() {
    return 'AssetsFilter(search: $search, status: $status, condition: $condition, categoryId: $categoryId, locationId: $locationId, assignedTo: $assignedTo, brand: $brand, model: $model, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';
  }
}

class AssetsState extends Equatable {
  final List<Asset> assets;
  final Asset? mutatedAsset;
  final AssetsFilter assetsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const AssetsState({
    this.assets = const [],
    this.mutatedAsset,
    required this.assetsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory AssetsState.initial() =>
      AssetsState(assetsFilter: AssetsFilter(), isLoading: true);

  factory AssetsState.loading({
    required AssetsFilter assetsFilter,
    List<Asset>? currentAssets,
  }) => AssetsState(
    assets: currentAssets ?? const [],
    assetsFilter: assetsFilter,
    isLoading: true,
  );

  factory AssetsState.success({
    required List<Asset> assets,
    required AssetsFilter assetsFilter,
    Cursor? cursor,
    String? message,
    Asset? mutatedAsset,
  }) => AssetsState(
    assets: assets,
    assetsFilter: assetsFilter,
    cursor: cursor,
    message: message,
    mutatedAsset: mutatedAsset,
  );

  factory AssetsState.error({
    required Failure failure,
    required AssetsFilter assetsFilter,
    List<Asset>? currentAssets,
  }) => AssetsState(
    assets: currentAssets ?? const [],
    assetsFilter: assetsFilter,
    failure: failure,
  );

  factory AssetsState.loadingMore({
    required List<Asset> currentAssets,
    required AssetsFilter assetsFilter,
    Cursor? cursor,
  }) => AssetsState(
    assets: currentAssets,
    assetsFilter: assetsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  AssetsState copyWith({
    List<Asset>? assets,
    ValueGetter<Asset?>? mutatedAsset,
    AssetsFilter? assetsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return AssetsState(
      assets: assets ?? this.assets,
      mutatedAsset: mutatedAsset != null ? mutatedAsset() : this.mutatedAsset,
      assetsFilter: assetsFilter ?? this.assetsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMutating: isMutating ?? this.isMutating,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  @override
  List<Object?> get props {
    return [
      assets,
      mutatedAsset,
      assetsFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
