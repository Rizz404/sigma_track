import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class CountCategoriesUsecase implements Usecase<ItemSuccess<int>, NoParams> {
  final CategoryRepository _categoryRepository;

  CountCategoriesUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(NoParams params) async {
    return await _categoryRepository.countCategories();
  }
}
