import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
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
  final int? limit;
  final String? cursor;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final String? assetId;
  final String? reportedById;
  final String? resolvedById;
  final String? issueType;
  final String? priority;
  final String? status;

  const GetIssueReportsCursorUsecaseParams({
    this.limit,
    this.cursor,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.assetId,
    this.reportedById,
    this.resolvedById,
    this.issueType,
    this.priority,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (limit != null) map['limit'] = limit;
    if (cursor != null) map['cursor'] = cursor;
    if (search != null) map['search'] = search;
    if (sortBy != null) map['sortBy'] = sortBy;
    if (sortOrder != null) map['sortOrder'] = sortOrder;
    if (assetId != null) map['assetId'] = assetId;
    if (reportedById != null) map['reportedById'] = reportedById;
    if (resolvedById != null) map['resolvedById'] = resolvedById;
    if (issueType != null) map['issueType'] = issueType;
    if (priority != null) map['priority'] = priority;
    if (status != null) map['status'] = status;
    return map;
  }

  @override
  List<Object?> get props => [
    limit,
    cursor,
    search,
    sortBy,
    sortOrder,
    assetId,
    reportedById,
    resolvedById,
    issueType,
    priority,
    status,
  ];
}
