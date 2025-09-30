import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement_statistics.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/check_asset_movement_exists_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/delete_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_cursor_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_by_asset_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movement_by_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_usecase.dart';

abstract class AssetMovementRepository {
  Future<Either<Failure, ItemSuccess<AssetMovement>>> createAssetMovement(
    CreateAssetMovementUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<AssetMovement>>>
  getAssetMovements(GetAssetMovementsUsecaseParams params);
  Future<Either<Failure, ItemSuccess<AssetMovementStatistics>>>
  getAssetMovementsStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<AssetMovement>>>
  getAssetMovementsCursor(GetAssetMovementsCursorUsecaseParams params);
  Future<Either<Failure, ItemSuccess<int>>> countAssetMovements();
  Future<Either<Failure, OffsetPaginatedSuccess<AssetMovement>>>
  getAssetMovementsByAssetId(GetAssetMovementsByAssetIdUsecaseParams params);
  Future<Either<Failure, ItemSuccess<bool>>> checkAssetMovementExists(
    CheckAssetMovementExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<AssetMovement>>> getAssetMovementById(
    GetAssetMovementByIdUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<AssetMovement>>> updateAssetMovement(
    UpdateAssetMovementUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<dynamic>>> deleteAssetMovement(
    DeleteAssetMovementUsecaseParams params,
  );
}
