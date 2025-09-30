import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class ReopenIssueReportUsecase
    implements
        Usecase<ItemSuccess<IssueReport>, ReopenIssueReportUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  ReopenIssueReportUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> call(
    ReopenIssueReportUsecaseParams params,
  ) async {
    return await _issueReportRepository.reopenIssueReport(params);
  }
}

class ReopenIssueReportUsecaseParams extends Equatable {
  final String id;

  const ReopenIssueReportUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
