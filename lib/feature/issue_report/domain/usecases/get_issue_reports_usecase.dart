import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class GetIssueReportsUsecase
    implements
        Usecase<OffsetPaginatedSuccess<dynamic>, GetIssueReportsUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  GetIssueReportsUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<dynamic>>> call(
    GetIssueReportsUsecaseParams params,
  ) async {
    return await _issueReportRepository.getIssueReports(params);
  }
}

class GetIssueReportsUsecaseParams extends Equatable {
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
  final int? limit;
  final int? offset;

  const GetIssueReportsUsecaseParams({
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
    this.limit,
    this.offset,
  });

  GetIssueReportsUsecaseParams copyWith({
    String? search,
    String? assetId,
    String? reportedBy,
    String? resolvedBy,
    String? issueType,
    IssuePriority? priority,
    IssueStatus? status,
    bool? isResolved,
    String? dateFrom,
    String? dateTo,
    IssueReportSortBy? sortBy,
    SortOrder? sortOrder,
    int? limit,
    int? offset,
  }) {
    return GetIssueReportsUsecaseParams(
      search: search ?? this.search,
      assetId: assetId ?? this.assetId,
      reportedBy: reportedBy ?? this.reportedBy,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      issueType: issueType ?? this.issueType,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      isResolved: isResolved ?? this.isResolved,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
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
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  factory GetIssueReportsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetIssueReportsUsecaseParams(
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
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetIssueReportsUsecaseParams.fromJson(String source) =>
      GetIssueReportsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetIssueReportsUsecaseParams(search: $search, assetId: $assetId, reportedBy: $reportedBy, resolvedBy: $resolvedBy, issueType: $issueType, priority: $priority, status: $status, isResolved: $isResolved, dateFrom: $dateFrom, dateTo: $dateTo, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, offset: $offset)';

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
    limit,
    offset,
  ];
}
