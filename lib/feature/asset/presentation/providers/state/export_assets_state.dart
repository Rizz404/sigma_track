import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';

class ExportAssetsState extends Equatable {
  final bool isLoading;
  final Failure? failure;
  final String? message;
  final Uint8List? previewData;

  const ExportAssetsState({
    this.isLoading = false,
    this.failure,
    this.message,
    this.previewData,
  });

  factory ExportAssetsState.initial() => const ExportAssetsState();

  ExportAssetsState copyWith({
    bool? isLoading,
    Failure? failure,
    String? message,
    Uint8List? previewData,
  }) {
    return ExportAssetsState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      previewData: previewData ?? this.previewData,
    );
  }

  @override
  List<Object?> get props => [isLoading, failure, message, previewData];
}
