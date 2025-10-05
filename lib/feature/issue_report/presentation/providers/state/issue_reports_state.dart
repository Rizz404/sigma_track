import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';

class IssueReportsFilter extends Equatable {
  final String? search;
  final String? assetId;
  final String? reportedBy;
  final String? resolvedBy;
  final String? issueType;
  final IssuePriority? priority;
  final IssueStatus? status;
  final bool? isResolved;
  final String? dateFrom;
  final String? dateTo;
  final IssueReportSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  IssueReportsFilter({
    this.search,
    this.assetId,
    this.reportedBy,
    this.resolvedBy,
    this.issueType,
    this.priority,
    this.status,
    this.isResolved,
    this.dateFrom,
    this.dateTo,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  IssueReportsFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? assetId,
    ValueGetter<String?>? reportedBy,
    ValueGetter<String?>? resolvedBy,
    ValueGetter<String?>? issueType,
    ValueGetter<IssuePriority?>? priority,
    ValueGetter<IssueStatus?>? status,
    ValueGetter<bool?>? isResolved,
    ValueGetter<String?>? dateFrom,
    ValueGetter<String?>? dateTo,
    ValueGetter<IssueReportSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return IssueReportsFilter(
      search: search != null ? search() : this.search,
      assetId: assetId != null ? assetId() : this.assetId,
      reportedBy: reportedBy != null ? reportedBy() : this.reportedBy,
      resolvedBy: resolvedBy != null ? resolvedBy() : this.resolvedBy,
      issueType: issueType != null ? issueType() : this.issueType,
      priority: priority != null ? priority() : this.priority,
      status: status != null ? status() : this.status,
      isResolved: isResolved != null ? isResolved() : this.isResolved,
      dateFrom: dateFrom != null ? dateFrom() : this.dateFrom,
      dateTo: dateTo != null ? dateTo() : this.dateTo,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  @override
  List<Object?> get props {
    return [
      search,
      assetId,
      reportedBy,
      resolvedBy,
      issueType,
      priority,
      status,
      isResolved,
      dateFrom,
      dateTo,
      sortBy,
      sortOrder,
      cursor,
      limit,
    ];
  }

  @override
  String toString() {
    return 'IssueReportsFilter(search: $search, assetId: $assetId, reportedBy: $reportedBy, resolvedBy: $resolvedBy, issueType: $issueType, priority: $priority, status: $status, isResolved: $isResolved, dateFrom: $dateFrom, dateTo: $dateTo, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';
  }
}

class IssueReportsState extends Equatable {
  final List<IssueReport> issueReports;
  final IssueReport? mutatedIssueReport;
  final IssueReportsFilter issueReportsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const IssueReportsState({
    this.issueReports = const [],
    this.mutatedIssueReport,
    required this.issueReportsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory IssueReportsState.initial() => IssueReportsState(
    issueReportsFilter: IssueReportsFilter(),
    isLoading: true,
  );

  factory IssueReportsState.loading({
    required IssueReportsFilter issueReportsFilter,
    List<IssueReport>? currentIssueReports,
  }) => IssueReportsState(
    issueReports: currentIssueReports ?? const [],
    issueReportsFilter: issueReportsFilter,
    isLoading: true,
  );

  factory IssueReportsState.success({
    required List<IssueReport> issueReports,
    required IssueReportsFilter issueReportsFilter,
    Cursor? cursor,
    String? message,
    IssueReport? mutatedIssueReport,
  }) => IssueReportsState(
    issueReports: issueReports,
    issueReportsFilter: issueReportsFilter,
    cursor: cursor,
    message: message,
    mutatedIssueReport: mutatedIssueReport,
  );

  factory IssueReportsState.error({
    required Failure failure,
    required IssueReportsFilter issueReportsFilter,
    List<IssueReport>? currentIssueReports,
  }) => IssueReportsState(
    issueReports: currentIssueReports ?? const [],
    issueReportsFilter: issueReportsFilter,
    failure: failure,
  );

  factory IssueReportsState.loadingMore({
    required List<IssueReport> currentIssueReports,
    required IssueReportsFilter issueReportsFilter,
    Cursor? cursor,
  }) => IssueReportsState(
    issueReports: currentIssueReports,
    issueReportsFilter: issueReportsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  IssueReportsState copyWith({
    List<IssueReport>? issueReports,
    ValueGetter<IssueReport?>? mutatedIssueReport,
    IssueReportsFilter? issueReportsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return IssueReportsState(
      issueReports: issueReports ?? this.issueReports,
      mutatedIssueReport: mutatedIssueReport != null
          ? mutatedIssueReport()
          : this.mutatedIssueReport,
      issueReportsFilter: issueReportsFilter ?? this.issueReportsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMutating: isMutating ?? this.isMutating,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  @override
  List<Object?> get props {
    return [
      issueReports,
      mutatedIssueReport,
      issueReportsFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
