import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/create_issue_report_usecase.dart';

class BulkCreateIssueReportsUsecase
    implements
        Usecase<
          ItemSuccess<BulkCreateIssueReportsResponse>,
          BulkCreateIssueReportsParams
        > {
  final IssueReportRepository _issueReportRepository;

  BulkCreateIssueReportsUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateIssueReportsResponse>>> call(
    BulkCreateIssueReportsParams params,
  ) async {
    return await _issueReportRepository.createManyIssueReports(params);
  }
}

class BulkCreateIssueReportsParams extends Equatable {
  final List<CreateIssueReportUsecaseParams> issueReports;

  const BulkCreateIssueReportsParams({required this.issueReports});

  Map<String, dynamic> toMap() {
    return {'issueReports': issueReports.map((x) => x.toMap()).toList()};
  }

  factory BulkCreateIssueReportsParams.fromMap(Map<String, dynamic> map) {
    return BulkCreateIssueReportsParams(
      issueReports: List<CreateIssueReportUsecaseParams>.from(
        (map['issueReports'] as List).map(
          (x) =>
              CreateIssueReportUsecaseParams.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateIssueReportsParams.fromJson(String source) =>
      BulkCreateIssueReportsParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [issueReports];
}

class BulkCreateIssueReportsResponse extends Equatable {
  final List<IssueReport> issueReports;

  const BulkCreateIssueReportsResponse({required this.issueReports});

  Map<String, dynamic> toMap() {
    return {
      'issueReports': issueReports.map((x) => _issueReportToMap(x)).toList(),
    };
  }

  factory BulkCreateIssueReportsResponse.fromMap(Map<String, dynamic> map) {
    return BulkCreateIssueReportsResponse(
      issueReports: List<IssueReport>.from(
        (map['issueReports'] as List).map(
          (x) => _issueReportFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateIssueReportsResponse.fromJson(String source) =>
      BulkCreateIssueReportsResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [issueReports];

  static Map<String, dynamic> _issueReportToMap(IssueReport issueReport) {
    return {
      'id': issueReport.id,
      'assetId': issueReport.assetId,
      'reportedById': issueReport.reportedById,
      'issueType': issueReport.issueType,
      'priority': issueReport.priority.value,
      'status': issueReport.status.value,
      'title': issueReport.title,
      'description': issueReport.description,
      'resolutionNotes': issueReport.resolutionNotes,
      'reportedDate': issueReport.reportedDate.toIso8601String(),
      'resolvedDate': issueReport.resolvedDate?.toIso8601String(),
      'createdAt': issueReport.createdAt.toIso8601String(),
      'updatedAt': issueReport.updatedAt.toIso8601String(),
    };
  }

  static IssueReport _issueReportFromMap(Map<String, dynamic> map) {
    return IssueReport(
      id: map['id'] ?? '',
      assetId: map['assetId'] ?? '',
      reportedById: map['reportedById'] ?? '',
      issueType: map['issueType'] ?? '',
      priority: IssuePriority.values.firstWhere(
        (e) => e.value == map['priority'],
        orElse: () => IssuePriority.low,
      ),
      status: IssueStatus.values.firstWhere(
        (e) => e.value == map['status'],
        orElse: () => IssueStatus.open,
      ),
      title: map['title'] ?? '',
      description: map['description'],
      resolutionNotes: map['resolutionNotes'],
      reportedDate: DateTime.parse(map['reportedDate'].toString()),
      resolvedDate: map['resolvedDate'] != null
          ? DateTime.parse(map['resolvedDate'].toString())
          : null,
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
    );
  }
}
