import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/asset_movements_notifier.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/check_asset_movement_exists_notifier.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/count_asset_movements_notifier.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/get_asset_movement_by_id_notifier.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/get_asset_movements_by_asset_id_notifier.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/get_asset_movements_statistics_notifier.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movement_boolean_state.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movement_count_state.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movement_detail_state.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movements_by_asset_state.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movements_state.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movement_statistics_state.dart';

final assetMovementsProvider =
    AutoDisposeNotifierProvider<AssetMovementsNotifier, AssetMovementsState>(
      AssetMovementsNotifier.new,
    );

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final assetMovementsSearchProvider =
    AutoDisposeNotifierProvider<AssetMovementsNotifier, AssetMovementsState>(
      AssetMovementsNotifier.new,
    );

final getAssetMovementByIdProvider =
    AutoDisposeNotifierProvider<
      GetAssetMovementByIdNotifier,
      AssetMovementDetailState
    >(GetAssetMovementByIdNotifier.new);

final checkAssetMovementExistsProvider =
    AutoDisposeNotifierProvider<
      CheckAssetMovementExistsNotifier,
      AssetMovementBooleanState
    >(CheckAssetMovementExistsNotifier.new);

final countAssetMovementsProvider =
    AutoDisposeNotifierProvider<
      CountAssetMovementsNotifier,
      AssetMovementCountState
    >(CountAssetMovementsNotifier.new);

final getAssetMovementsStatisticsProvider =
    AutoDisposeNotifierProvider<
      GetAssetMovementsStatisticsNotifier,
      AssetMovementStatisticsState
    >(GetAssetMovementsStatisticsNotifier.new);

final getAssetMovementsByAssetIdProvider =
    AutoDisposeNotifierProvider<
      GetAssetMovementsByAssetIdNotifier,
      AssetMovementsByAssetState
    >(GetAssetMovementsByAssetIdNotifier.new);
