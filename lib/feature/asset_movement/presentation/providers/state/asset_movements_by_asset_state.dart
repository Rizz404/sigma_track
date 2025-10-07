import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';

class AssetMovementsByAssetFilter extends Equatable {
  final String assetId;
  final String? search;
  final String? fromLocationId;
  final String? toLocationId;
  final String? fromUserId;
  final String? toUserId;
  final String? movedBy;
  final String? dateFrom;
  final String? dateTo;
  final AssetMovementSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  AssetMovementsByAssetFilter({
    required this.assetId,
    this.search,
    this.fromLocationId,
    this.toLocationId,
    this.fromUserId,
    this.toUserId,
    this.movedBy,
    this.dateFrom,
    this.dateTo,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  AssetMovementsByAssetFilter copyWith({
    String? assetId,
    ValueGetter<String?>? search,
    ValueGetter<String?>? fromLocationId,
    ValueGetter<String?>? toLocationId,
    ValueGetter<String?>? fromUserId,
    ValueGetter<String?>? toUserId,
    ValueGetter<String?>? movedBy,
    ValueGetter<String?>? dateFrom,
    ValueGetter<String?>? dateTo,
    ValueGetter<AssetMovementSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return AssetMovementsByAssetFilter(
      assetId: assetId ?? this.assetId,
      search: search != null ? search() : this.search,
      fromLocationId: fromLocationId != null
          ? fromLocationId()
          : this.fromLocationId,
      toLocationId: toLocationId != null ? toLocationId() : this.toLocationId,
      fromUserId: fromUserId != null ? fromUserId() : this.fromUserId,
      toUserId: toUserId != null ? toUserId() : this.toUserId,
      movedBy: movedBy != null ? movedBy() : this.movedBy,
      dateFrom: dateFrom != null ? dateFrom() : this.dateFrom,
      dateTo: dateTo != null ? dateTo() : this.dateTo,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  @override
  List<Object?> get props => [
    assetId,
    search,
    fromLocationId,
    toLocationId,
    fromUserId,
    toUserId,
    movedBy,
    dateFrom,
    dateTo,
    sortBy,
    sortOrder,
    cursor,
    limit,
  ];
}

class AssetMovementsByAssetState extends Equatable {
  final List<AssetMovement> assetMovements;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? failure;
  final AssetMovementsByAssetFilter filter;
  final bool hasMore;

  const AssetMovementsByAssetState({
    this.assetMovements = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.failure,
    required this.filter,
    this.hasMore = true,
  });

  factory AssetMovementsByAssetState.initial(
    AssetMovementsByAssetFilter filter,
  ) => AssetMovementsByAssetState(filter: filter);

  AssetMovementsByAssetState copyWith({
    List<AssetMovement>? assetMovements,
    bool? isLoading,
    bool? isLoadingMore,
    Failure? failure,
    AssetMovementsByAssetFilter? filter,
    bool? hasMore,
  }) {
    return AssetMovementsByAssetState(
      assetMovements: assetMovements ?? this.assetMovements,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure ?? this.failure,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    assetMovements,
    isLoading,
    isLoadingMore,
    failure,
    filter,
    hasMore,
  ];
}
