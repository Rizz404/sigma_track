import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/asset_movement/data/models/asset_movement_model.dart';
import 'package:sigma_track/feature/asset_movement/data/models/asset_movement_statistics_model.dart';
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
import 'package:sigma_track/feature/asset_movement/domain/usecases/bulk_create_asset_movements_for_user_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/bulk_create_asset_movements_for_location_usecase.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

abstract class AssetMovementRemoteDatasource {
  Future<ApiOffsetPaginationResponse<AssetMovementModel>> getAssetMovements(
    GetAssetMovementsUsecaseParams params,
  );
  Future<ApiResponse<AssetMovementStatisticsModel>>
  getAssetMovementsStatistics();
  Future<ApiCursorPaginationResponse<AssetMovementModel>>
  getAssetMovementsCursor(GetAssetMovementsCursorUsecaseParams params);
  Future<ApiResponse<int>> countAssetMovements(
    CountAssetMovementsUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<AssetMovementModel>>
  getAssetMovementsByAssetId(GetAssetMovementsByAssetIdUsecaseParams params);
  Future<ApiResponse<bool>> checkAssetMovementExists(
    CheckAssetMovementExistsUsecaseParams params,
  );
  Future<ApiResponse<AssetMovementModel>> getAssetMovementById(
    GetAssetMovementByIdUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteAssetMovement(
    DeleteAssetMovementUsecaseParams params,
  );
  Future<ApiResponse<AssetMovementModel>> createAssetMovementForLocation(
    CreateAssetMovementForLocationUsecaseParams params,
  );
  Future<ApiResponse<AssetMovementModel>> createAssetMovementForUser(
    CreateAssetMovementForUserUsecaseParams params,
  );
  Future<ApiResponse<AssetMovementModel>> updateAssetMovementForLocation(
    UpdateAssetMovementForLocationUsecaseParams params,
  );
  Future<ApiResponse<AssetMovementModel>> updateAssetMovementForUser(
    UpdateAssetMovementForUserUsecaseParams params,
  );
  Future<ApiResponse<Uint8List>> exportAssetMovementList(
    ExportAssetMovementListUsecaseParams params,
  );
  Future<ApiResponse<BulkCreateAssetMovementsForUserResponse>>
  createManyAssetMovements(BulkCreateAssetMovementsForUserParams params);
  Future<ApiResponse<BulkCreateAssetMovementsForLocationResponse>>
  createManyAssetMovementsForLocation(
    BulkCreateAssetMovementsForLocationParams params,
  );
  Future<ApiResponse<BulkDeleteResponse>> deleteManyAssetMovements(
    BulkDeleteParams params,
  );
}

class AssetMovementRemoteDatasourceImpl
    implements AssetMovementRemoteDatasource {
  final DioClient _dioClient;

  AssetMovementRemoteDatasourceImpl(this._dioClient);

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
  Future<ApiResponse<int>> countAssetMovements(
    CountAssetMovementsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countAssetMovements,
        fromJson: (json) => json as int,
        queryParameters: params.toMap(),
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

  @override
  Future<ApiResponse<AssetMovementModel>> createAssetMovementForLocation(
    CreateAssetMovementForLocationUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createAssetMovementForLocation,
        data: params.toMap(),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetMovementModel>> createAssetMovementForUser(
    CreateAssetMovementForUserUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createAssetMovementForUser,
        data: params.toMap(),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetMovementModel>> updateAssetMovementForLocation(
    UpdateAssetMovementForLocationUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.patch(
        ApiConstant.updateAssetMovementForLocation(params.id),
        data: params.toMap(),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AssetMovementModel>> updateAssetMovementForUser(
    UpdateAssetMovementForUserUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.patch(
        ApiConstant.updateAssetMovementForUser(params.id),
        data: params.toMap(),
        fromJson: (json) => AssetMovementModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<Uint8List>> exportAssetMovementList(
    ExportAssetMovementListUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.postForBinary(
        ApiConstant.exportAssetMovementList,
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
  Future<ApiResponse<BulkCreateAssetMovementsForUserResponse>>
  createManyAssetMovements(BulkCreateAssetMovementsForUserParams params) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.bulkCreateAssetMovements,
        data: params.toMap(),
        fromJson: (json) =>
            BulkCreateAssetMovementsForUserResponse.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<BulkCreateAssetMovementsForLocationResponse>>
  createManyAssetMovementsForLocation(
    BulkCreateAssetMovementsForLocationParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.bulkCreateAssetMovements,
        data: params.toMap(),
        fromJson: (json) =>
            BulkCreateAssetMovementsForLocationResponse.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<BulkDeleteResponse>> deleteManyAssetMovements(
    BulkDeleteParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.bulkDeleteAssetMovements,
        data: params.toMap(),
        fromJson: (json) => BulkDeleteResponse.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
