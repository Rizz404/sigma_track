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
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_for_location_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_for_user_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/delete_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_cursor_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_by_asset_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movement_by_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_for_location_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_for_user_usecase.dart';

class AssetMovementRepositoryImpl implements AssetMovementRepository {
  final AssetMovementRemoteDatasource _assetMovementRemoteDatasource;

  AssetMovementRepositoryImpl(this._assetMovementRemoteDatasource);

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

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>>
  createAssetMovementForLocation(
    CreateAssetMovementForLocationUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource
          .createAssetMovementForLocation(params);
      final assetMovement = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: assetMovement));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>>
  createAssetMovementForUser(
    CreateAssetMovementForUserUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource
          .createAssetMovementForUser(params);
      final assetMovement = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: assetMovement));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>>
  updateAssetMovementForLocation(
    UpdateAssetMovementForLocationUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource
          .updateAssetMovementForLocation(params);
      final assetMovement = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: assetMovement));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>>
  updateAssetMovementForUser(
    UpdateAssetMovementForUserUsecaseParams params,
  ) async {
    try {
      final response = await _assetMovementRemoteDatasource
          .updateAssetMovementForUser(params);
      final assetMovement = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: assetMovement));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
