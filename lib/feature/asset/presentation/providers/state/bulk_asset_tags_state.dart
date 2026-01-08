import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset/domain/entities/generate_bulk_asset_tags_response.dart';

enum BulkAssetTagsStatus { initial, loading, success, error }

class BulkAssetTagsState extends Equatable {
  final BulkAssetTagsStatus status;
  final GenerateBulkAssetTagsResponse? data;
  final String? message;
  final Failure? failure;

  const BulkAssetTagsState({
    required this.status,
    this.data,
    this.message,
    this.failure,
  });

  factory BulkAssetTagsState.initial() {
    return const BulkAssetTagsState(status: BulkAssetTagsStatus.initial);
  }

  factory BulkAssetTagsState.loading() {
    return const BulkAssetTagsState(status: BulkAssetTagsStatus.loading);
  }

  factory BulkAssetTagsState.success(
    GenerateBulkAssetTagsResponse data, {
    String? message,
  }) {
    return BulkAssetTagsState(
      status: BulkAssetTagsStatus.success,
      data: data,
      message: message,
    );
  }

  factory BulkAssetTagsState.error(Failure failure) {
    return BulkAssetTagsState(
      status: BulkAssetTagsStatus.error,
      failure: failure,
    );
  }

  BulkAssetTagsState copyWith({
    BulkAssetTagsStatus? status,
    ValueGetter<GenerateBulkAssetTagsResponse?>? data,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return BulkAssetTagsState(
      status: status ?? this.status,
      data: data != null ? data() : this.data,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [status, data, message, failure];
}
