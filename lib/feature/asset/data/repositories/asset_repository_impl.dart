import 'dart:typed_data';

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
import 'package:sigma_track/feature/asset/domain/entities/generate_asset_tag_response.dart';
import 'package:sigma_track/feature/asset/domain/entities/generate_bulk_asset_tags_response.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_bulk_data_matrix_response.dart';
import 'package:sigma_track/feature/asset/domain/entities/delete_bulk_data_matrix_response.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_bulk_asset_image_response.dart';
import 'package:sigma_track/feature/asset/domain/entities/delete_bulk_asset_image_response.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_template_images_response.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_serial_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_tag_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/count_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_list_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/generate_asset_tag_suggestion_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/generate_bulk_asset_tags_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_bulk_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_bulk_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_bulk_asset_image_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_bulk_asset_image_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_template_images_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_id_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_tag_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/update_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/bulk_create_assets_usecase.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

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
  Future<Either<Failure, ItemSuccess<int>>> countAssets(
    CountAssetsUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.countAssets(params);
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

  @override
  Future<Either<Failure, ItemSuccess<GenerateAssetTagResponse>>>
  generateAssetTagSuggestion(
    GenerateAssetTagSuggestionUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.generateAssetTagSuggestion(
        params,
      );
      final suggestion = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: suggestion));
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
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportAssetList(
    ExportAssetListUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.exportAssetList(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportAssetDataMatrix(
    ExportAssetDataMatrixUsecaseParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.exportAssetDataMatrix(
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
  Future<Either<Failure, ItemSuccess<BulkCreateAssetsResponse>>>
  createManyAssets(BulkCreateAssetsParams params) async {
    try {
      final response = await _assetRemoteDatasource.createManyAssets(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> deleteManyAssets(
    BulkDeleteParams params,
  ) async {
    try {
      final response = await _assetRemoteDatasource.deleteManyAssets(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<GenerateBulkAssetTagsResponse>>>
  generateBulkAssetTags(GenerateBulkAssetTagsUsecaseParams params) async {
    try {
      final response = await _assetRemoteDatasource.generateBulkAssetTags(
        params,
      );
      final result = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: result));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<UploadBulkDataMatrixResponse>>>
  uploadBulkDataMatrix(UploadBulkDataMatrixUsecaseParams params) async {
    try {
      final response = await _assetRemoteDatasource.uploadBulkDataMatrix(
        params,
      );
      final result = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: result));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<DeleteBulkDataMatrixResponse>>>
  deleteBulkDataMatrix(DeleteBulkDataMatrixUsecaseParams params) async {
    try {
      final response = await _assetRemoteDatasource.deleteBulkDataMatrix(
        params,
      );
      final result = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: result));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<UploadBulkAssetImageResponse>>>
  uploadBulkAssetImage(UploadBulkAssetImageUsecaseParams params) async {
    try {
      final response = await _assetRemoteDatasource.uploadBulkAssetImage(
        params,
      );
      final result = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: result));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<DeleteBulkAssetImageResponse>>>
  deleteBulkAssetImage(DeleteBulkAssetImageUsecaseParams params) async {
    try {
      final response = await _assetRemoteDatasource.deleteBulkAssetImage(
        params,
      );
      final result = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: result));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<UploadTemplateImagesResponse>>>
  uploadTemplateImages(UploadTemplateImagesUsecaseParams params) async {
    try {
      final response = await _assetRemoteDatasource.uploadTemplateImages(
        params,
      );
      final result = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: result));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
