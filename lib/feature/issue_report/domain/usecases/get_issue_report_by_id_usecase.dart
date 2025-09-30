import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class GetIssueReportByIdUsecase
    implements
        Usecase<ItemSuccess<IssueReport>, GetIssueReportByIdUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  GetIssueReportByIdUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> call(
    GetIssueReportByIdUsecaseParams params,
  ) async {
    return await _issueReportRepository.getIssueReportById(params);
  }
}

class GetIssueReportByIdUsecaseParams extends Equatable {
  final String id;

  const GetIssueReportByIdUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
