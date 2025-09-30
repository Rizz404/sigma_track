import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report_statistics.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class GetIssueReportsStatisticsUsecase
    implements Usecase<ItemSuccess<IssueReportStatistics>, NoParams> {
  final IssueReportRepository _issueReportRepository;

  GetIssueReportsStatisticsUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<IssueReportStatistics>>> call(
    NoParams params,
  ) async {
    return await _issueReportRepository.getIssueReportsStatistics();
  }
}
