import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class ExportIssueReportListUsecase
    implements
        Usecase<ItemSuccess<Uint8List>, ExportIssueReportListUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  ExportIssueReportListUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> call(
    ExportIssueReportListUsecaseParams params,
  ) async {
    return await _issueReportRepository.exportIssueReportList(params);
  }
}

class ExportIssueReportListUsecaseParams extends Equatable {
  final ExportFormat format;
  final String? searchQuery;
  final String? issueType;
  final IssuePriority? priority;
  final IssueStatus? status;
  final String? assetId;
  final String? reportedBy;
  final DateTime? startDate;
  final DateTime? endDate;
  final IssueReportSortBy? sortBy;
  final SortOrder? sortOrder;

  const ExportIssueReportListUsecaseParams({
    required this.format,
    this.searchQuery,
    this.issueType,
    this.priority,
    this.status,
    this.assetId,
    this.reportedBy,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.sortOrder,
  });

  ExportIssueReportListUsecaseParams copyWith({
    ExportFormat? format,
    String? searchQuery,
    String? issueType,
    IssuePriority? priority,
    IssueStatus? status,
    String? assetId,
    String? reportedBy,
    DateTime? startDate,
    DateTime? endDate,
    IssueReportSortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return ExportIssueReportListUsecaseParams(
      format: format ?? this.format,
      searchQuery: searchQuery ?? this.searchQuery,
      issueType: issueType ?? this.issueType,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assetId: assetId ?? this.assetId,
      reportedBy: reportedBy ?? this.reportedBy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'format': format.value,
      if (searchQuery != null) 'searchQuery': searchQuery,
      if (issueType != null) 'issueType': issueType,
      if (priority != null) 'priority': priority!.value,
      if (status != null) 'status': status!.value,
      if (assetId != null) 'assetId': assetId,
      if (reportedBy != null) 'reportedBy': reportedBy,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
    };
  }

  factory ExportIssueReportListUsecaseParams.fromMap(Map<String, dynamic> map) {
    return ExportIssueReportListUsecaseParams(
      format: ExportFormat.values.firstWhere((e) => e.value == map['format']),
      searchQuery: map['searchQuery'],
      issueType: map['issueType'],
      priority: map['priority'] != null
          ? IssuePriority.values.firstWhere((e) => e.value == map['priority'])
          : null,
      status: map['status'] != null
          ? IssueStatus.values.firstWhere((e) => e.value == map['status'])
          : null,
      assetId: map['assetId'],
      reportedBy: map['reportedBy'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      sortBy: map['sortBy'] != null
          ? IssueReportSortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExportIssueReportListUsecaseParams.fromJson(String source) =>
      ExportIssueReportListUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'ExportIssueReportListUsecaseParams(format: $format, searchQuery: $searchQuery, issueType: $issueType, priority: $priority, status: $status, assetId: $assetId, reportedBy: $reportedBy, startDate: $startDate, endDate: $endDate, sortBy: $sortBy, sortOrder: $sortOrder)';

  @override
  List<Object?> get props => [
    format,
    searchQuery,
    issueType,
    priority,
    status,
    assetId,
    reportedBy,
    startDate,
    endDate,
    sortBy,
    sortOrder,
  ];
}
