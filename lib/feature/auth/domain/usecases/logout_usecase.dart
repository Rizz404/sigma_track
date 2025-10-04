import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase implements Usecase<ActionSuccess, NoParams> {
  final AuthRepository _authRepository;

  LogoutUsecase(this._authRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(NoParams params) async {
    return await _authRepository.logout();
  }
}
