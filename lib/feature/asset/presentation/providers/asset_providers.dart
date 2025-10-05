import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/asset/presentation/providers/assets_notifier.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';

final assetsProvider = AutoDisposeNotifierProvider<AssetsNotifier, AssetsState>(
  AssetsNotifier.new,
);
