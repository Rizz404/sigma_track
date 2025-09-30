import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/entities/location_statistics.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_code_exists_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_exists_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/create_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/delete_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_cursor_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_code_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_id_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/update_location_usecase.dart';

abstract class LocationRepository {
  Future<Either<Failure, ItemSuccess<Location>>> createLocation(
    CreateLocationUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<Location>>> getLocations(
    GetLocationsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<LocationStatistics>>>
  getLocationsStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<Location>>> getLocationsCursor(
    GetLocationsCursorUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<int>>> countLocations();
  Future<Either<Failure, ItemSuccess<Location>>> getLocationByCode(
    GetLocationByCodeUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkLocationCodeExists(
    CheckLocationCodeExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkLocationExists(
    CheckLocationExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Location>>> getLocationById(
    GetLocationByIdUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Location>>> updateLocation(
    UpdateLocationUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> deleteLocation(
    DeleteLocationUsecaseParams params,
  );
}
