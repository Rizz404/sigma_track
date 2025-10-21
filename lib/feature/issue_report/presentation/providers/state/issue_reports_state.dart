import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_cursor_usecase.dart';

// * State untuk mutation operation yang lebih descriptive
class IssueReportMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;

  const IssueReportMutationState({
    required this.type,
    this.isLoading = false,
    this.successMessage,
    this.failure,
  });

  bool get isSuccess => successMessage != null && failure == null;
  bool get isError => failure != null;

  @override
  List<Object?> get props => [type, isLoading, successMessage, failure];
}

class IssueReportsState extends Equatable {
  final List<IssueReport> issueReports;
  final GetIssueReportsCursorUsecaseParams issueReportsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final IssueReportMutationState? mutation;
  final Failure? failure;
  final Cursor? cursor;

  const IssueReportsState({
    this.issueReports = const [],
    required this.issueReportsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.mutation,
    this.failure,
    this.cursor,
  });

  // * Computed properties untuk kemudahan di UI
  bool get isMutating => mutation?.isLoading ?? false;
  bool get isCreating =>
      mutation?.type == MutationType.create && mutation!.isLoading;
  bool get isUpdating =>
      mutation?.type == MutationType.update && mutation!.isLoading;
  bool get isDeleting =>
      mutation?.type == MutationType.delete && mutation!.isLoading;
  bool get hasMutationSuccess => mutation?.isSuccess ?? false;
  bool get hasMutationError => mutation?.isError ?? false;
  String? get mutationMessage => mutation?.successMessage;
  Failure? get mutationFailure => mutation?.failure;

  // * Factory methods yang lebih descriptive
  factory IssueReportsState.initial() => const IssueReportsState(
    issueReportsFilter: GetIssueReportsCursorUsecaseParams(),
    isLoading: true,
  );

  factory IssueReportsState.loading({
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    List<IssueReport>? currentIssueReports,
  }) => IssueReportsState(
    issueReports: currentIssueReports ?? const [],
    issueReportsFilter: issueReportsFilter,
    isLoading: true,
  );

  factory IssueReportsState.success({
    required List<IssueReport> issueReports,
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    Cursor? cursor,
  }) => IssueReportsState(
    issueReports: issueReports,
    issueReportsFilter: issueReportsFilter,
    cursor: cursor,
  );

  factory IssueReportsState.error({
    required Failure failure,
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    List<IssueReport>? currentIssueReports,
  }) => IssueReportsState(
    issueReports: currentIssueReports ?? const [],
    issueReportsFilter: issueReportsFilter,
    failure: failure,
  );

  factory IssueReportsState.loadingMore({
    required List<IssueReport> currentIssueReports,
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    Cursor? cursor,
  }) => IssueReportsState(
    issueReports: currentIssueReports,
    issueReportsFilter: issueReportsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Factory methods untuk mutation states
  factory IssueReportsState.creating({
    required List<IssueReport> currentIssueReports,
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    Cursor? cursor,
  }) => IssueReportsState(
    issueReports: currentIssueReports,
    issueReportsFilter: issueReportsFilter,
    cursor: cursor,
    mutation: const IssueReportMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory IssueReportsState.updating({
    required List<IssueReport> currentIssueReports,
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    Cursor? cursor,
  }) => IssueReportsState(
    issueReports: currentIssueReports,
    issueReportsFilter: issueReportsFilter,
    cursor: cursor,
    mutation: const IssueReportMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory IssueReportsState.deleting({
    required List<IssueReport> currentIssueReports,
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    Cursor? cursor,
  }) => IssueReportsState(
    issueReports: currentIssueReports,
    issueReportsFilter: issueReportsFilter,
    cursor: cursor,
    mutation: const IssueReportMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory IssueReportsState.mutationSuccess({
    required List<IssueReport> issueReports,
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    required MutationType mutationType,
    required String message,
    Cursor? cursor,
  }) => IssueReportsState(
    issueReports: issueReports,
    issueReportsFilter: issueReportsFilter,
    cursor: cursor,
    mutation: IssueReportMutationState(
      type: mutationType,
      successMessage: message,
    ),
  );

  factory IssueReportsState.mutationError({
    required List<IssueReport> currentIssueReports,
    required GetIssueReportsCursorUsecaseParams issueReportsFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => IssueReportsState(
    issueReports: currentIssueReports,
    issueReportsFilter: issueReportsFilter,
    cursor: cursor,
    mutation: IssueReportMutationState(type: mutationType, failure: failure),
  );

  IssueReportsState copyWith({
    List<IssueReport>? issueReports,
    GetIssueReportsCursorUsecaseParams? issueReportsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<IssueReportMutationState?>? mutation,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return IssueReportsState(
      issueReports: issueReports ?? this.issueReports,
      issueReportsFilter: issueReportsFilter ?? this.issueReportsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      mutation: mutation != null ? mutation() : this.mutation,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Helper untuk clear mutation state setelah handled
  IssueReportsState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      issueReports,
      issueReportsFilter,
      isLoading,
      isLoadingMore,
      mutation,
      failure,
      cursor,
    ];
  }
}
