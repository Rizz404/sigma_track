import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/asset_movements_notifier.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movements_state.dart';

final assetMovementsProvider =
    AutoDisposeNotifierProvider<AssetMovementsNotifier, AssetMovementsState>(
      AssetMovementsNotifier.new,
    );

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final assetMovementsSearchProvider =
    AutoDisposeNotifierProvider<AssetMovementsNotifier, AssetMovementsState>(
      AssetMovementsNotifier.new,
    );
