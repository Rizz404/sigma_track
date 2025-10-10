
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class GetCurrentUserUsecase implements Usecase<ItemSuccess<User>, NoParams> {
  final UserRepository _userRepository;

  GetCurrentUserUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<User>>> call(NoParams params) async {
    return await _userRepository.getCurrentUser();
  }
}
