import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user_personal_statistics.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class GetUserPersonalStatisticsUseCase
    implements Usecase<ItemSuccess<UserPersonalStatistics>, NoParams> {
  final UserRepository _userRepository;

  GetUserPersonalStatisticsUseCase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<UserPersonalStatistics>>> call(
    NoParams params,
  ) async {
    return await _userRepository.getUserPersonalStatistics();
  }
}
