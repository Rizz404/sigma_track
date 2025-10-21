import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class GetIssueReportsCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<dynamic>,
          GetIssueReportsCursorUsecaseParams
        > {
  final IssueReportRepository _issueReportRepository;

  GetIssueReportsCursorUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<dynamic>>> call(
    GetIssueReportsCursorUsecaseParams params,
  ) async {
    return await _issueReportRepository.getIssueReportsCursor(params);
  }
}

class GetIssueReportsCursorUsecaseParams extends Equatable {
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

  const GetIssueReportsCursorUsecaseParams({
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

  GetIssueReportsCursorUsecaseParams copyWith({
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
    return GetIssueReportsCursorUsecaseParams(
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

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (assetId != null) 'assetId': assetId,
      if (reportedBy != null) 'reportedBy': reportedBy,
      if (resolvedBy != null) 'resolvedBy': resolvedBy,
      if (issueType != null) 'issueType': issueType,
      if (priority != null) 'priority': priority!.value,
      if (status != null) 'status': status!.value,
      if (isResolved != null) 'isResolved': isResolved,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetIssueReportsCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetIssueReportsCursorUsecaseParams(
      search: map['search'],
      assetId: map['assetId'],
      reportedBy: map['reportedBy'],
      resolvedBy: map['resolvedBy'],
      issueType: map['issueType'],
      priority: map['priority'] != null
          ? IssuePriority.values.firstWhere((e) => e.value == map['priority'])
          : null,
      status: map['status'] != null
          ? IssueStatus.values.firstWhere((e) => e.value == map['status'])
          : null,
      isResolved: map['isResolved'],
      dateFrom: map['dateFrom'],
      dateTo: map['dateTo'],
      sortBy: map['sortBy'] != null
          ? IssueReportSortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetIssueReportsCursorUsecaseParams.fromJson(String source) =>
      GetIssueReportsCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetIssueReportsCursorUsecaseParams(search: $search, assetId: $assetId, reportedBy: $reportedBy, resolvedBy: $resolvedBy, issueType: $issueType, priority: $priority, status: $status, isResolved: $isResolved, dateFrom: $dateFrom, dateTo: $dateTo, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [
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
