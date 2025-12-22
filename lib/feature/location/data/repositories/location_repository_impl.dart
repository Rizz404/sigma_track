import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/location/data/datasources/location_remote_datasource.dart';
import 'package:sigma_track/feature/location/data/mapper/location_mappers.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/entities/location_statistics.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_code_exists_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_exists_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/count_locations_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/create_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/delete_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_cursor_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_code_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_id_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/update_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/bulk_create_locations_usecase.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDatasource _locationRemoteDatasource;

  LocationRepositoryImpl(this._locationRemoteDatasource);

  @override
  Future<Either<Failure, ItemSuccess<Location>>> createLocation(
    CreateLocationUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.createLocation(params);
      final location = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: location));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<Location>>> getLocations(
    GetLocationsUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.getLocations(params);
      final locations = response.data.map((model) => model.toEntity()).toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: locations,
          pagination: response.pagination.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<LocationStatistics>>>
  getLocationsStatistics() async {
    try {
      final response = await _locationRemoteDatasource.getLocationsStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<Location>>> getLocationsCursor(
    GetLocationsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.getLocationsCursor(
        params,
      );
      final locations = response.data.map((model) => model.toEntity()).toList();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: locations,
          cursor: response.cursor.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<int>>> countLocations(
    CountLocationsUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.countLocations(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Location>>> getLocationByCode(
    GetLocationByCodeUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.getLocationByCode(
        params,
      );
      final location = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: location));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkLocationCodeExists(
    CheckLocationCodeExistsUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.checkLocationCodeExists(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkLocationExists(
    CheckLocationExistsUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.checkLocationExists(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Location>>> getLocationById(
    GetLocationByIdUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.getLocationById(params);
      final location = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: location));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Location>>> updateLocation(
    UpdateLocationUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.updateLocation(params);
      final location = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: location));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> deleteLocation(
    DeleteLocationUsecaseParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.deleteLocation(params);
      return Right(ActionSuccess(message: response.message));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateLocationsResponse>>>
  createManyLocations(BulkCreateLocationsParams params) async {
    try {
      final response = await _locationRemoteDatasource.createManyLocations(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> deleteManyLocations(
    BulkDeleteParams params,
  ) async {
    try {
      final response = await _locationRemoteDatasource.deleteManyLocations(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
