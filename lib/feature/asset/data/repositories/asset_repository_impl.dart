import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/asset/data/datasources/asset_remote_datasource.dart';
import 'package:sigma_track/feature/asset/data/mapper/asset_mappers.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_statistics.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_serial_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_tag_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_id_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_tag_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/update_asset_usecase.dart';

class AssetRepositoryImpl implements AssetRepository {
  final AssetRemoteDatasource _assetRemoteDatasource;

  AssetRepositoryImpl(this._assetRemoteDatasource);

  @override
  Future<Either<Failure, ItemSuccess<Asset>>> createAsset(
    CreateAssetUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.createAsset(params);
      final asset = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: asset));
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
      } else {
        return Left(ServerFailure(message: apiError.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<Asset>>> getAssets(
    GetAssetsUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.getAssets(params);
      final assets = response.data.map((model) => model.toEntity()).toList();
      final pagination = response.pagination.toEntity();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: assets,
          pagination: pagination,
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<AssetStatistics>>>
  getAssetsStatistics() async {
    try {
      final response = await _assetRemoteDatasource.getAssetsStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<Asset>>> getAssetsCursor(
    GetAssetsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.getAssetsCursor(params);
      final assets = response.data.map((model) => model.toEntity()).toList();
      final cursor = response.cursor.toEntity();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: assets,
          cursor: cursor,
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<int>>> countAssets() async {
    try {
      final response = await _assetRemoteDatasource.countAssets();
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Asset>>> getAssetByTag(
    GetAssetByTagUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.getAssetByTag(params);
      final asset = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: asset));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkAssetTagExists(
    CheckAssetTagExistsUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.checkAssetTagExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkAssetSerialExists(
    CheckAssetSerialExistsUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.checkAssetSerialExists(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkAssetExists(
    CheckAssetExistsUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.checkAssetExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Asset>>> getAssetById(
    GetAssetByIdUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.getAssetById(params);
      final asset = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: asset));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Asset>>> updateAsset(
    UpdateAssetUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.updateAsset(params);
      final asset = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: asset));
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
      } else {
        return Left(ServerFailure(message: apiError.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> deleteAsset(
    DeleteAssetUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.deleteAsset(params);
      return Right(ActionSuccess(message: response.message));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
