import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/auth/domain/entities/auth.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

class GetCurrentAuthUsecase implements Usecase<ItemSuccess<Auth>, NoParams> {
  final AuthRepository _authRepository;

  GetCurrentAuthUsecase(this._authRepository);

  @override
  Future<Either<Failure, ItemSuccess<Auth>>> call(NoParams params) async {
    return await _authRepository.getCurrentAuth();
  }
}
