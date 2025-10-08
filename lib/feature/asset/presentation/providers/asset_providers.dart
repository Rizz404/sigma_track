import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/asset/domain/usecases/count_assets_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/assets_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/assets_search_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_statistics_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/check_asset_exists_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/check_asset_serial_exists_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/check_asset_tag_exists_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/count_assets_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/get_asset_by_id_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/get_asset_by_tag_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_boolean_state.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_count_state.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_detail_state.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_statistics_state.dart';

// * Main list provider untuk asset (cursor pagination)
final assetsProvider = AutoDisposeNotifierProvider<AssetsNotifier, AssetsState>(
  AssetsNotifier.new,
);

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final assetsSearchProvider =
    AutoDisposeNotifierProvider<AssetsSearchNotifier, AssetsState>(
      AssetsSearchNotifier.new,
    );

// * Provider untuk check apakah asset exists
final checkAssetExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckAssetExistsNotifier,
      AssetBooleanState,
      String
    >(CheckAssetExistsNotifier.new);

// * Provider untuk check apakah asset serial exists
final checkAssetSerialExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckAssetSerialExistsNotifier,
      AssetBooleanState,
      String
    >(CheckAssetSerialExistsNotifier.new);

// * Provider untuk check apakah asset tag exists
final checkAssetTagExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckAssetTagExistsNotifier,
      AssetBooleanState,
      String
    >(CheckAssetTagExistsNotifier.new);

// * Provider untuk count assets
final countAssetsProvider =
    AutoDisposeNotifierProviderFamily<
      CountAssetsNotifier,
      AssetCountState,
      CountAssetsUsecaseParams
    >(CountAssetsNotifier.new);

// * Provider untuk asset statistics
final assetStatisticsProvider =
    AutoDisposeNotifierProvider<AssetStatisticsNotifier, AssetStatisticsState>(
      AssetStatisticsNotifier.new,
    );

// * Provider untuk get asset by id
final getAssetByIdProvider =
    AutoDisposeNotifierProviderFamily<
      GetAssetByIdNotifier,
      AssetDetailState,
      String
    >(GetAssetByIdNotifier.new);

// * Provider untuk get asset by tag
final getAssetByTagProvider =
    AutoDisposeNotifierProviderFamily<
      GetAssetByTagNotifier,
      AssetDetailState,
      String
    >(GetAssetByTagNotifier.new);
