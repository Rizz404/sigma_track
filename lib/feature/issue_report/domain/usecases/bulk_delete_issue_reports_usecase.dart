import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

class BulkDeleteIssueReportsUsecase
    implements Usecase<ItemSuccess<BulkDeleteResponse>, BulkDeleteParams> {
  final IssueReportRepository _issueReportRepository;

  BulkDeleteIssueReportsUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> call(
    BulkDeleteParams params,
  ) async {
    return await _issueReportRepository.deleteManyIssueReports(params);
  }
}
