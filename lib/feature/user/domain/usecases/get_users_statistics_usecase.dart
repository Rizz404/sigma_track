import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user_statistics.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class GetUsersStatisticsUsecase
    implements Usecase<ItemSuccess<UserStatistics>, NoParams> {
  final UserRepository _userRepository;

  GetUsersStatisticsUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<UserStatistics>>> call(
    NoParams params,
  ) async {
    return await _userRepository.getUsersStatistics();
  }
}
