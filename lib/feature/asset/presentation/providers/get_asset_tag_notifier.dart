import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/generate_asset_tag_suggestion_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_tag_suggestion_state.dart';

class GetAssetTagNotifier
    extends AutoDisposeFamilyNotifier<AssetTagSuggestionState, String> {
  GenerateAssetTagSuggestionUsecase get _enerateAssetTagSuggestionUsecase =>
      ref.watch(getGenerateAssetTagSuggestionProvider);

  @override
  AssetTagSuggestionState build(String categoryId) {
    ref.cacheFor(const Duration(minutes: 3));
    this.logPresentation('Loading asset tag: $categoryId');
    _loadAssetTag(categoryId);
    return AssetTagSuggestionState.initial();
  }

  Future<void> _loadAssetTag(String categoryId) async {
    state = AssetTagSuggestionState.loading();

    final result = await _enerateAssetTagSuggestionUsecase.call(
      GenerateAssetTagSuggestionUsecaseParams(categoryId: categoryId),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load asset tags', failure);
        state = AssetTagSuggestionState.error(failure);
      },
      (success) {
        this.logData('Asset tag loaded: ${success.data?.suggestedTag}');
        if (success.data != null) {
          state = AssetTagSuggestionState.success(success.data!);
        } else {
          state = AssetTagSuggestionState.error(
            const ServerFailure(message: 'Asset tag not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadAssetTag(arg);
  }
}
