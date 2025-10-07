import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';

// * State untuk single scan log (getById)
class ScanLogDetailState extends Equatable {
  final ScanLog? scanLog;
  final bool isLoading;
  final Failure? failure;

  const ScanLogDetailState({
    this.scanLog,
    this.isLoading = false,
    this.failure,
  });

  factory ScanLogDetailState.initial() =>
      const ScanLogDetailState(isLoading: true);

  factory ScanLogDetailState.loading() =>
      const ScanLogDetailState(isLoading: true);

  factory ScanLogDetailState.success(ScanLog scanLog) =>
      ScanLogDetailState(scanLog: scanLog);

  factory ScanLogDetailState.error(Failure failure) =>
      ScanLogDetailState(failure: failure);

  ScanLogDetailState copyWith({
    ScanLog? scanLog,
    bool? isLoading,
    Failure? failure,
  }) {
    return ScanLogDetailState(
      scanLog: scanLog ?? this.scanLog,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [scanLog, isLoading, failure];
}
