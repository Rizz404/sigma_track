import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/generate_bulk_asset_tags_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/bulk_asset_tags_state.dart';

class GenerateBulkAssetTagsNotifier
    extends AutoDisposeNotifier<BulkAssetTagsState> {
  GenerateBulkAssetTagsUsecase get _generateBulkAssetTagsUsecase =>
      ref.watch(generateBulkAssetTagsUsecaseProvider);

  @override
  BulkAssetTagsState build() {
    this.logPresentation('Initializing GenerateBulkAssetTagsNotifier');
    return BulkAssetTagsState.initial();
  }

  Future<void> generateTags(String categoryId, int quantity) async {
    this.logPresentation(
      'Generating $quantity bulk asset tags for category $categoryId',
    );

    state = BulkAssetTagsState.loading();

    final result = await _generateBulkAssetTagsUsecase.call(
      GenerateBulkAssetTagsUsecaseParams(
        categoryId: categoryId,
        quantity: quantity,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to generate bulk asset tags', failure);
        state = BulkAssetTagsState.error(failure);
      },
      (success) {
        if (success.data != null) {
          this.logData(
            'Generated ${success.data!.tags.length} tags: ${success.data!.startTag} - ${success.data!.endTag}',
          );
          state = BulkAssetTagsState.success(
            success.data!,
            message: success.message,
          );
        } else {
          this.logError(
            'Failed to generate bulk asset tags',
            'No data returned',
          );
          state = BulkAssetTagsState.error(
            const ServerFailure(message: 'No data returned'),
          );
        }
      },
    );
  }

  void clearState() {
    this.logPresentation('Clearing bulk asset tags state');
    state = BulkAssetTagsState.initial();
  }
}

final generateBulkAssetTagsNotifierProvider =
    AutoDisposeNotifierProvider<
      GenerateBulkAssetTagsNotifier,
      BulkAssetTagsState
    >(GenerateBulkAssetTagsNotifier.new);
