import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/location/domain/entities/location_statistics.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

class GetLocationsStatisticsUsecase
    implements Usecase<ItemSuccess<LocationStatistics>, NoParams> {
  final LocationRepository _locationRepository;

  GetLocationsStatisticsUsecase(this._locationRepository);

  @override
  Future<Either<Failure, ItemSuccess<LocationStatistics>>> call(
    NoParams params,
  ) async {
    return await _locationRepository.getLocationsStatistics();
  }
}
