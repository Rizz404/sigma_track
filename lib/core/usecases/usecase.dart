import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
