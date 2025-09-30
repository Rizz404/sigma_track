import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/asset_movement/data/models/asset_movement_model.dart';
import 'package:sigma_track/feature/asset_movement/data/models/asset_movement_statistics_model.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/check_asset_movement_exists_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/delete_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_cursor_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_by_asset_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movement_by_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_usecase.dart';

abstract class AssetMovementRemoteDatasource {
  Future<ApiResponse<AssetMovementModel>> createAssetMovement(
    CreateAssetMovementUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<AssetMovementModel>> getAssetMovements(
    GetAssetMovementsUsecaseParams params,
  );
  Future<ApiResponse<AssetMovementStatisticsModel>>
  getAssetMovementsStatistics();
  Future<ApiCursorPaginationResponse<AssetMovementModel>>
  getAssetMovementsCursor(GetAssetMovementsCursorUsecaseParams params);
  Future<ApiResponse<int>> countAssetMovements();
  Future<ApiOffsetPaginationResponse<AssetMovementModel>>
  getAssetMovementsByAssetId(GetAssetMovementsByAssetIdUsecaseParams params);
  Future<ApiResponse<bool>> checkAssetMovementExists(
    CheckAssetMovementExistsUsecaseParams params,
  );
  Future<ApiResponse<AssetMovementModel>> getAssetMovementById(
    GetAssetMovementByIdUsecaseParams params,
  );
  Future<ApiResponse<AssetMovementModel>> updateAssetMovement(
    UpdateAssetMovementUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteAssetMovement(
    DeleteAssetMovementUsecaseParams params,
  );
}

class AssetMovementRemoteDatasourceImpl
    implements AssetMovementRemoteDatasource {
  final DioClient _dioClient;

  AssetMovementRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<AssetMovementModel>> createAssetMovement(
    CreateAssetMovementUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createAssetMovement,
        data: params.toMap(),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<AssetMovementModel>> getAssetMovements(
    GetAssetMovementsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getAssetMovements,
        queryParameters: params.toMap(),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetMovementStatisticsModel>>
  getAssetMovementsStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getAssetMovementsStatistics,
        fromJson: (json) => AssetMovementStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<AssetMovementModel>>
  getAssetMovementsCursor(GetAssetMovementsCursorUsecaseParams params) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getAssetMovementsCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countAssetMovements() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countAssetMovements,
        fromJson: (json) => json as int,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<AssetMovementModel>>
  getAssetMovementsByAssetId(
    GetAssetMovementsByAssetIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getAssetMovementsByAssetId(params.assetId),
        queryParameters: params.toMap(),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkAssetMovementExists(
    CheckAssetMovementExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkAssetMovementExists(params.id),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetMovementModel>> getAssetMovementById(
    GetAssetMovementByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getAssetMovementById(params.id),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetMovementModel>> updateAssetMovement(
    UpdateAssetMovementUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.put(
        ApiConstant.updateAssetMovement(params.id),
        data: params.toMap(),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteAssetMovement(
    DeleteAssetMovementUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteAssetMovement(params.id),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
