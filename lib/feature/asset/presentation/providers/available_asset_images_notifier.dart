import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/entities/image_response.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_available_asset_images_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/available_asset_images_state.dart';

class AvailableAssetImagesNotifier
    extends AutoDisposeNotifier<AvailableAssetImagesState> {
  GetAvailableAssetImagesCursorUsecase get _getAvailableAssetImagesUsecase =>
      ref.watch(getAvailableAssetImagesUsecaseProvider);

  @override
  AvailableAssetImagesState build() {
    this.logPresentation('Initializing AvailableAssetImagesNotifier');
    _initializeImages();
    return AvailableAssetImagesState.initial();
  }

  Future<void> _initializeImages() async {
    state = await _loadImages(
      filter: const GetAvailableAssetImagesCursorUsecaseParams(),
    );
  }

  Future<AvailableAssetImagesState> _loadImages({
    required GetAvailableAssetImagesCursorUsecaseParams filter,
    List<ImageResponse>? currentImages,
  }) async {
    this.logPresentation('Loading available asset images with filter: $filter');

    final result = await _getAvailableAssetImagesUsecase(filter);

    return result.fold(
      (failure) {
        this.logError('Failed to load images', failure);
        return AvailableAssetImagesState.error(
          failure: failure,
          currentImages: currentImages,
        );
      },
      (success) {
        final images = success.data ?? [];
        final allImages = currentImages != null
            ? [...currentImages, ...images]
            : images;

        this.logData(
          'Images loaded: ${images.length} items, total: ${allImages.length}',
        );
        return AvailableAssetImagesState.success(
          images: allImages,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.cursor == null || !state.cursor!.hasNextPage) {
      this.logPresentation('No more images to load');
      return;
    }

    if (state.isLoadingMore) {
      this.logPresentation('Already loading more');
      return;
    }

    this.logPresentation('Loading more images');

    state = AvailableAssetImagesState.loadingMore(
      currentImages: state.images,
      cursor: state.cursor,
    );

    final filter = GetAvailableAssetImagesCursorUsecaseParams(
      cursor: state.cursor?.nextCursor,
    );

    final result = await _getAvailableAssetImagesUsecase(filter);

    result.fold(
      (failure) {
        this.logError('Failed to load more images', failure);
        state = AvailableAssetImagesState.error(
          failure: failure,
          currentImages: state.images,
        );
      },
      (success) {
        final images = success.data ?? [];
        final allImages = [...state.images, ...images];

        this.logData('More images loaded: ${images.length}');
        state = AvailableAssetImagesState.success(
          images: allImages,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> refresh() async {
    this.logPresentation('Refreshing images');
    state = state.copyWith(isLoading: true);
    state = await _loadImages(
      filter: const GetAvailableAssetImagesCursorUsecaseParams(),
    );
  }
}
