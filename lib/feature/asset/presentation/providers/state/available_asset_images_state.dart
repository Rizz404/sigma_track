import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/asset/domain/entities/image_response.dart';

class AvailableAssetImagesState extends Equatable {
  final List<ImageResponse> images;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? failure;
  final Cursor? cursor;

  const AvailableAssetImagesState({
    this.images = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.failure,
    this.cursor,
  });

  // * Factory methods yang lebih descriptive
  factory AvailableAssetImagesState.initial() =>
      const AvailableAssetImagesState(isLoading: true);

  factory AvailableAssetImagesState.loading({
    List<ImageResponse>? currentImages,
  }) => AvailableAssetImagesState(
    images: currentImages ?? const [],
    isLoading: true,
  );

  factory AvailableAssetImagesState.success({
    required List<ImageResponse> images,
    required Cursor cursor,
  }) => AvailableAssetImagesState(images: images, cursor: cursor);

  factory AvailableAssetImagesState.error({
    required Failure failure,
    List<ImageResponse>? currentImages,
  }) => AvailableAssetImagesState(
    images: currentImages ?? const [],
    failure: failure,
  );

  factory AvailableAssetImagesState.loadingMore({
    required List<ImageResponse> currentImages,
    required Cursor? cursor,
  }) => AvailableAssetImagesState(
    images: currentImages,
    isLoadingMore: true,
    cursor: cursor,
  );

  AvailableAssetImagesState copyWith({
    List<ImageResponse>? images,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<Failure?>? failure,
    Cursor? cursor,
  }) {
    return AvailableAssetImagesState(
      images: images ?? this.images,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor ?? this.cursor,
    );
  }

  @override
  List<Object?> get props => [
    images,
    isLoading,
    isLoadingMore,
    failure,
    cursor,
  ];
}
