import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_statistics.dart';
import 'package:sigma_track/feature/asset/domain/entities/generate_asset_tag_response.dart';
import 'package:sigma_track/feature/asset/domain/entities/generate_bulk_asset_tags_response.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_bulk_data_matrix_response.dart';
import 'package:sigma_track/feature/asset/domain/entities/delete_bulk_data_matrix_response.dart';
import 'package:sigma_track/feature/asset/domain/usecases/bulk_create_assets_usecase.dart';
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
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_id_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_tag_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/update_asset_usecase.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

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
  Future<Either<Failure, ItemSuccess<GenerateAssetTagResponse>>>
  generateAssetTagSuggestion(GenerateAssetTagSuggestionUsecaseParams params);
  Future<Either<Failure, ItemSuccess<GenerateBulkAssetTagsResponse>>>
  generateBulkAssetTags(GenerateBulkAssetTagsUsecaseParams params);
  Future<Either<Failure, ItemSuccess<UploadBulkDataMatrixResponse>>>
  uploadBulkDataMatrix(UploadBulkDataMatrixUsecaseParams params);
  Future<Either<Failure, ItemSuccess<DeleteBulkDataMatrixResponse>>>
  deleteBulkDataMatrix(DeleteBulkDataMatrixUsecaseParams params);
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportAssetList(
    ExportAssetListUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportAssetDataMatrix(
    ExportAssetDataMatrixUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<BulkCreateAssetsResponse>>>
  createManyAssets(BulkCreateAssetsParams params);
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> deleteManyAssets(
    BulkDeleteParams params,
  );
}
