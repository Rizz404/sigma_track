import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';

class IssueReportBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const IssueReportBooleanState({
    this.result,
    this.isLoading = false,
    this.failure,
  });

  factory IssueReportBooleanState.initial() => const IssueReportBooleanState();

  IssueReportBooleanState copyWith({
    bool? result,
    bool? isLoading,
    Failure? failure,
  }) {
    return IssueReportBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
