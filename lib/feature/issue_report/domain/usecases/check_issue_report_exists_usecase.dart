import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class CheckIssueReportExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckIssueReportExistsUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  CheckIssueReportExistsUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckIssueReportExistsUsecaseParams params,
  ) async {
    return await _issueReportRepository.checkIssueReportExists(params);
  }
}

class CheckIssueReportExistsUsecaseParams extends Equatable {
  final String id;

  const CheckIssueReportExistsUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
