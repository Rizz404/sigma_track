import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/asset/data/models/asset_statistics_model.dart';
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

abstract class AssetRemoteDatasource {
  Future<ApiResponse<AssetModel>> createAsset(CreateAssetUsecaseParams params);
  Future<ApiOffsetPaginationResponse<AssetModel>> getAssets(
    GetAssetsUsecaseParams params,
  );
  Future<ApiResponse<AssetStatisticsModel>> getAssetsStatistics();
  Future<ApiCursorPaginationResponse<AssetModel>> getAssetsCursor(
    GetAssetsCursorUsecaseParams params,
  );
  Future<ApiResponse<int>> countAssets();
  Future<ApiResponse<AssetModel>> getAssetByTag(
    GetAssetByTagUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkAssetTagExists(
    CheckAssetTagExistsUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkAssetSerialExists(
    CheckAssetSerialExistsUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkAssetExists(
    CheckAssetExistsUsecaseParams params,
  );
  Future<ApiResponse<AssetModel>> getAssetById(
    GetAssetByIdUsecaseParams params,
  );
  Future<ApiResponse<AssetModel>> updateAsset(UpdateAssetUsecaseParams params);
  Future<ApiResponse<dynamic>> deleteAsset(DeleteAssetUsecaseParams params);
}

class AssetRemoteDatasourceImpl implements AssetRemoteDatasource {
  final DioClient _dioClient;

  AssetRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<AssetModel>> createAsset(
    CreateAssetUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createAsset,
        data: params.toMap(),
        fromJson: (json) => AssetModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<AssetModel>> getAssets(
    GetAssetsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getAssets,
        queryParameters: params.toMap(),
        fromJson: (json) => AssetModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetStatisticsModel>> getAssetsStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getAssetsStatistics,
        fromJson: (json) => AssetStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<AssetModel>> getAssetsCursor(
    GetAssetsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getAssetsCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => AssetModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countAssets() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countAssets,
        fromJson: (json) => json as int,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetModel>> getAssetByTag(
    GetAssetByTagUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getAssetByTag(params.tag),
        fromJson: (json) => AssetModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkAssetTagExists(
    CheckAssetTagExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkAssetTagExists(params.tag),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkAssetSerialExists(
    CheckAssetSerialExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkAssetSerialExists(params.serial),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkAssetExists(
    CheckAssetExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkAssetExists(params.id),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetModel>> getAssetById(
    GetAssetByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getAssetById(params.id),
        fromJson: (json) => AssetModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetModel>> updateAsset(
    UpdateAssetUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.put(
        ApiConstant.updateAsset(params.id),
        data: params.toMap(),
        fromJson: (json) => AssetModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteAsset(
    DeleteAssetUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteAsset(params.id),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
