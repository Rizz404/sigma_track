import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class ResolveIssueReportUsecase
    implements
        Usecase<ItemSuccess<IssueReport>, ResolveIssueReportUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  ResolveIssueReportUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> call(
    ResolveIssueReportUsecaseParams params,
  ) async {
    return await _issueReportRepository.resolveIssueReport(params);
  }
}

class ResolveIssueReportUsecaseParams extends Equatable {
  final String id;
  final String resolvedById;
  final String? resolutionNotes;

  ResolveIssueReportUsecaseParams({
    required this.id,
    required this.resolvedById,
    this.resolutionNotes,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'resolvedById': resolvedById};
    if (resolutionNotes != null) map['resolutionNotes'] = resolutionNotes;
    return map;
  }

  factory ResolveIssueReportUsecaseParams.fromMap(Map<String, dynamic> map) {
    return ResolveIssueReportUsecaseParams(
      id: map['id'] ?? '',
      resolvedById: map['resolvedById'] ?? '',
      resolutionNotes: map['resolutionNotes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ResolveIssueReportUsecaseParams.fromJson(String source) =>
      ResolveIssueReportUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [id, resolvedById, resolutionNotes];
}
