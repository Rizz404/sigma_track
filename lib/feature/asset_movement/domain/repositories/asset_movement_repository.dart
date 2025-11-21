import 'dart:typed_data';

import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement_statistics.dart';
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
import 'package:sigma_track/feature/asset_movement/domain/usecases/export_asset_movement_list_usecase.dart';

abstract class AssetMovementRepository {
  Future<Either<Failure, OffsetPaginatedSuccess<AssetMovement>>>
  getAssetMovements(GetAssetMovementsUsecaseParams params);
  Future<Either<Failure, ItemSuccess<AssetMovementStatistics>>>
  getAssetMovementsStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<AssetMovement>>>
  getAssetMovementsCursor(GetAssetMovementsCursorUsecaseParams params);
  Future<Either<Failure, ItemSuccess<int>>> countAssetMovements(
    CountAssetMovementsUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<AssetMovement>>>
  getAssetMovementsByAssetId(GetAssetMovementsByAssetIdUsecaseParams params);
  Future<Either<Failure, ItemSuccess<bool>>> checkAssetMovementExists(
    CheckAssetMovementExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<AssetMovement>>> getAssetMovementById(
    GetAssetMovementByIdUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<dynamic>>> deleteAssetMovement(
    DeleteAssetMovementUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<AssetMovement>>>
  createAssetMovementForLocation(
    CreateAssetMovementForLocationUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<AssetMovement>>>
  createAssetMovementForUser(CreateAssetMovementForUserUsecaseParams params);
  Future<Either<Failure, ItemSuccess<AssetMovement>>>
  updateAssetMovementForLocation(
    UpdateAssetMovementForLocationUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<AssetMovement>>>
  updateAssetMovementForUser(UpdateAssetMovementForUserUsecaseParams params);
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportAssetMovementList(
    ExportAssetMovementListUsecaseParams params,
  );
}
