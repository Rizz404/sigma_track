import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class CountIssueReportsUsecase implements Usecase<ItemSuccess<int>, NoParams> {
  final IssueReportRepository _issueReportRepository;

  CountIssueReportsUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(NoParams params) async {
    return await _issueReportRepository.countIssueReports();
  }
}
