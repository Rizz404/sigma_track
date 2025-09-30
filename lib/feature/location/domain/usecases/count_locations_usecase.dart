import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class CountLocationsUsecase implements Usecase<ItemSuccess<int>, NoParams> {
  final LocationRepository _locationRepository;

  CountLocationsUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(NoParams params) async {
    return await _locationRepository.countLocations();
  }
}
