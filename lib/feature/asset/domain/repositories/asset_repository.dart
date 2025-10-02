import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_statistics.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_serial_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_tag_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/count_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_id_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_tag_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/update_asset_usecase.dart';

abstract class AssetRepository {
  Future<Either<Failure, ItemSuccess<Asset>>> createAsset(
    CreateAssetUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<Asset>>> getAssets(
    GetAssetsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<AssetStatistics>>> getAssetsStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<Asset>>> getAssetsCursor(
    GetAssetsCursorUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<int>>> countAssets(
    CountAssetsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Asset>>> getAssetByTag(
    GetAssetByTagUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkAssetTagExists(
    CheckAssetTagExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkAssetSerialExists(
    CheckAssetSerialExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkAssetExists(
    CheckAssetExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Asset>>> getAssetById(
    GetAssetByIdUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Asset>>> updateAsset(
    UpdateAssetUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> deleteAsset(
    DeleteAssetUsecaseParams params,
  );
}
