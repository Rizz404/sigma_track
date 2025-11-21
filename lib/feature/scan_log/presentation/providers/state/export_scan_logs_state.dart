import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

class ExportScanLogsState extends Equatable {
  final bool isLoading;
  final Failure? failure;
  final String? message;
  final Uint8List? previewData;

  const ExportScanLogsState({
    this.isLoading = false,
    this.failure,
    this.message,
    this.previewData,
  });

  factory ExportScanLogsState.initial() => const ExportScanLogsState();

  ExportScanLogsState copyWith({
    bool? isLoading,
    Failure? failure,
    String? message,
    Uint8List? previewData,
  }) {
    return ExportScanLogsState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
      message: message ?? this.message,
      previewData: previewData ?? this.previewData,
    );
  }

  @override
  List<Object?> get props => [isLoading, failure, message, previewData];
}
