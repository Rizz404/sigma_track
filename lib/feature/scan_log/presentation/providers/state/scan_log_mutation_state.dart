import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';

enum ScanLogStatus { initial, loading, error, success }

class ScanLogMutationState extends Equatable {
  final ScanLogStatus scanLogStatus;
  final ScanLog? scanLog;
  final String? message;
  final Failure? failure;

  const ScanLogMutationState({
    required this.scanLogStatus,
    this.scanLog,
    this.message,
    this.failure,
  });

  factory ScanLogMutationState.success({ScanLog? scanLog, String? message}) {
    return ScanLogMutationState(
      scanLogStatus: ScanLogStatus.success,
      scanLog: scanLog,
      message: message,
    );
  }

  factory ScanLogMutationState.error({Failure? failure}) {
    return ScanLogMutationState(
      scanLogStatus: ScanLogStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }

  ScanLogMutationState copyWith({
    ScanLogStatus? scanLogStatus,
    ValueGetter<ScanLog?>? scanLog,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return ScanLogMutationState(
      scanLogStatus: scanLogStatus ?? this.scanLogStatus,
      scanLog: scanLog != null ? scanLog() : this.scanLog,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [scanLogStatus, scanLog, message, failure];
}
