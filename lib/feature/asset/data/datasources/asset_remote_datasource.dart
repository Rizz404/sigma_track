import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/asset/data/models/asset_statistics_model.dart';
import 'package:sigma_track/feature/asset/data/models/generate_asset_tag_response_model.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_serial_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_tag_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/count_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_list_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/generate_asset_tag_suggestion_usecase.dart';
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
  Future<ApiResponse<int>> countAssets(CountAssetsUsecaseParams params);
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
  Future<ApiResponse<GenerateAssetTagResponseModel>> generateAssetTagSuggestion(
    GenerateAssetTagSuggestionUsecaseParams params,
  );
  Future<ApiResponse<Uint8List>> exportAssetList(
    ExportAssetListUsecaseParams params,
  );
  Future<ApiResponse<Uint8List>> exportAssetDataMatrix(
    ExportAssetDataMatrixUsecaseParams params,
  );
}

class AssetRemoteDatasourceImpl implements AssetRemoteDatasource {
  final DioClient _dioClient;

  AssetRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<AssetModel>> createAsset(
    CreateAssetUsecaseParams params,
  ) async {
    this.logData('createAsset called');
    try {
      final formData = dio.FormData();
      final map = params.toMap();
      for (final entry in map.entries) {
        if (entry.key == 'dataMatrixImageFile' && entry.value != null) {
          formData.files.add(
            MapEntry(
              'dataMatrixImage',
              await dio.MultipartFile.fromFile(entry.value as String),
            ),
          );
        } else if (entry.value != null && entry.key != 'dataMatrixImageFile') {
          formData.fields.add(MapEntry(entry.key, entry.value.toString()));
        }
      }
      final response = await _dioClient.post(
        ApiConstant.createAsset,
        data: formData,
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
    this.logData('getAssets called');
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
    this.logData('getAssetsStatistics called');
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
    this.logData('getAssetsCursor called');
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
  Future<ApiResponse<int>> countAssets(CountAssetsUsecaseParams params) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countAssets,
        queryParameters: params.toMap(),
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
      final formData = dio.FormData();
      final map = params.toMap();
      for (final entry in map.entries) {
        if (entry.key == 'dataMatrixImageFile' && entry.value != null) {
          formData.files.add(
            MapEntry(
              'dataMatrixImage',
              await dio.MultipartFile.fromFile(entry.value as String),
            ),
          );
        } else if (entry.value != null && entry.key != 'dataMatrixImageFile') {
          formData.fields.add(MapEntry(entry.key, entry.value.toString()));
        }
      }
      final response = await _dioClient.patch(
        ApiConstant.updateAsset(params.id),
        data: formData,
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

  @override
  Future<ApiResponse<GenerateAssetTagResponseModel>> generateAssetTagSuggestion(
    GenerateAssetTagSuggestionUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.generateAssetTagSuggestion,
        fromJson: (json) => GenerateAssetTagResponseModel.fromMap(json),
        data: params.toMap(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<Uint8List>> exportAssetList(
    ExportAssetListUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.postForBinary(
        ApiConstant.exportAssetList,
        data: params.toMap(),
        options: dio.Options(responseType: dio.ResponseType.bytes),
        fromData: (data) => data as Uint8List,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<Uint8List>> exportAssetDataMatrix(
    ExportAssetDataMatrixUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.postForBinary(
        ApiConstant.exportAssetDataMatrix,
        data: params.toMap(),
        options: dio.Options(responseType: dio.ResponseType.bytes),
        fromData: (data) => data as Uint8List,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
