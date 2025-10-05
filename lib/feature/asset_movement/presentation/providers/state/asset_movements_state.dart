import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';

class AssetMovementsFilter extends Equatable {
  final String? search;
  final String? assetId;
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

  AssetMovementsFilter({
    this.search,
    this.assetId,
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

  AssetMovementsFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? assetId,
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
    return AssetMovementsFilter(
      search: search != null ? search() : this.search,
      assetId: assetId != null ? assetId() : this.assetId,
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
  List<Object?> get props {
    return [
      search,
      assetId,
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

  @override
  String toString() {
    return 'AssetMovementsFilter(search: $search, assetId: $assetId, fromLocationId: $fromLocationId, toLocationId: $toLocationId, fromUserId: $fromUserId, toUserId: $toUserId, movedBy: $movedBy, dateFrom: $dateFrom, dateTo: $dateTo, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';
  }
}

class AssetMovementsState extends Equatable {
  final List<AssetMovement> assetMovements;
  final AssetMovement? mutatedAssetMovement;
  final AssetMovementsFilter assetMovementsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const AssetMovementsState({
    this.assetMovements = const [],
    this.mutatedAssetMovement,
    required this.assetMovementsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory AssetMovementsState.initial() => AssetMovementsState(
    assetMovementsFilter: AssetMovementsFilter(),
    isLoading: true,
  );

  factory AssetMovementsState.loading({
    required AssetMovementsFilter assetMovementsFilter,
    List<AssetMovement>? currentAssetMovements,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements ?? const [],
    assetMovementsFilter: assetMovementsFilter,
    isLoading: true,
  );

  factory AssetMovementsState.success({
    required List<AssetMovement> assetMovements,
    required AssetMovementsFilter assetMovementsFilter,
    Cursor? cursor,
    String? message,
    AssetMovement? mutatedAssetMovement,
  }) => AssetMovementsState(
    assetMovements: assetMovements,
    assetMovementsFilter: assetMovementsFilter,
    cursor: cursor,
    message: message,
    mutatedAssetMovement: mutatedAssetMovement,
  );

  factory AssetMovementsState.error({
    required Failure failure,
    required AssetMovementsFilter assetMovementsFilter,
    List<AssetMovement>? currentAssetMovements,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements ?? const [],
    assetMovementsFilter: assetMovementsFilter,
    failure: failure,
  );

  factory AssetMovementsState.loadingMore({
    required List<AssetMovement> currentAssetMovements,
    required AssetMovementsFilter assetMovementsFilter,
    Cursor? cursor,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements,
    assetMovementsFilter: assetMovementsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  AssetMovementsState copyWith({
    List<AssetMovement>? assetMovements,
    ValueGetter<AssetMovement?>? mutatedAssetMovement,
    AssetMovementsFilter? assetMovementsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return AssetMovementsState(
      assetMovements: assetMovements ?? this.assetMovements,
      mutatedAssetMovement: mutatedAssetMovement != null
          ? mutatedAssetMovement()
          : this.mutatedAssetMovement,
      assetMovementsFilter: assetMovementsFilter ?? this.assetMovementsFilter,
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
      assetMovements,
      mutatedAssetMovement,
      assetMovementsFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
