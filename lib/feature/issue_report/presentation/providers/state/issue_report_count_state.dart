import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';

class IssueReportCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const IssueReportCountState({
    this.count,
    this.isLoading = false,
    this.failure,
  });

  factory IssueReportCountState.initial() => const IssueReportCountState();

  IssueReportCountState copyWith({
    int? count,
    bool? isLoading,
    Failure? failure,
  }) {
    return IssueReportCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
