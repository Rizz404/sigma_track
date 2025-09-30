import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class DeleteIssueReportUsecase
    implements Usecase<ActionSuccess, DeleteIssueReportUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  DeleteIssueReportUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    DeleteIssueReportUsecaseParams params,
  ) async {
    return await _issueReportRepository.deleteIssueReport(params);
  }
}

class DeleteIssueReportUsecaseParams extends Equatable {
  final String id;

  const DeleteIssueReportUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
