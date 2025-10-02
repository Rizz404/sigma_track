import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/asset_movement/data/datasources/asset_movement_remote_datasource.dart';
import 'package:sigma_track/feature/asset_movement/data/mapper/asset_movement_mappers.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement_statistics.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/check_asset_movement_exists_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/count_asset_movements_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/delete_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_cursor_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_by_asset_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movement_by_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_usecase.dart';

class AssetMovementRepositoryImpl implements AssetMovementRepository {
  final AssetMovementRemoteDatasource _assetMovementRemoteDatasource;

  AssetMovementRepositoryImpl(this._assetMovementRemoteDatasource);

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> createAssetMovement(
    CreateAssetMovementUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource.createAssetMovement(
        params,
      );
      final assetMovement = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: assetMovement));
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
  Future<Either<Failure, OffsetPaginatedSuccess<AssetMovement>>>
  getAssetMovements(GetAssetMovementsUsecaseParams params) async {
    try {
      final response = await _assetMovementRemoteDatasource.getAssetMovements(
        params,
      );
      final assetMovements = response.data
          .map((model) => model.toEntity())
          .toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: assetMovements,
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
  Future<Either<Failure, ItemSuccess<AssetMovementStatistics>>>
  getAssetMovementsStatistics() async {
    try {
      final response = await _assetMovementRemoteDatasource
          .getAssetMovementsStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<AssetMovement>>>
  getAssetMovementsCursor(GetAssetMovementsCursorUsecaseParams params) async {
    try {
      final response = await _assetMovementRemoteDatasource
          .getAssetMovementsCursor(params);
      final assetMovements = response.data
          .map((model) => model.toEntity())
          .toList();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: assetMovements,
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
  Future<Either<Failure, ItemSuccess<int>>> countAssetMovements(
    CountAssetMovementsUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource.countAssetMovements(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<AssetMovement>>>
  getAssetMovementsByAssetId(
    GetAssetMovementsByAssetIdUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource
          .getAssetMovementsByAssetId(params);
      final assetMovements = response.data
          .map((model) => model.toEntity())
          .toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: assetMovements,
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
  Future<Either<Failure, ItemSuccess<bool>>> checkAssetMovementExists(
    CheckAssetMovementExistsUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource
          .checkAssetMovementExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> getAssetMovementById(
    GetAssetMovementByIdUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource
          .getAssetMovementById(params);
      final assetMovement = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: assetMovement));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> updateAssetMovement(
    UpdateAssetMovementUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource.updateAssetMovement(
        params,
      );
      final assetMovement = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: assetMovement));
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
  Future<Either<Failure, ItemSuccess<dynamic>>> deleteAssetMovement(
    DeleteAssetMovementUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource.deleteAssetMovement(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
