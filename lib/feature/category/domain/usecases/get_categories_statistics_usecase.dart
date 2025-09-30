import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category_statistics.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class GetCategoriesStatisticsUsecase
    implements Usecase<ItemSuccess<CategoryStatistics>, NoParams> {
  final CategoryRepository _categoryRepository;

  GetCategoriesStatisticsUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<CategoryStatistics>>> call(
    NoParams params,
  ) async {
    return await _categoryRepository.getCategoriesStatistics();
  }
}
