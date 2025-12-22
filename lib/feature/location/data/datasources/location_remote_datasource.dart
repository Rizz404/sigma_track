import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/location/data/models/location_model.dart';
import 'package:sigma_track/feature/location/data/models/location_statistics_model.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_code_exists_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_exists_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/count_locations_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/create_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/delete_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_cursor_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_code_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_id_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/update_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/bulk_create_locations_usecase.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

abstract class LocationRemoteDatasource {
  Future<ApiResponse<LocationModel>> createLocation(
    CreateLocationUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<LocationModel>> getLocations(
    GetLocationsUsecaseParams params,
  );
  Future<ApiResponse<LocationStatisticsModel>> getLocationsStatistics();
  Future<ApiCursorPaginationResponse<LocationModel>> getLocationsCursor(
    GetLocationsCursorUsecaseParams params,
  );
  Future<ApiResponse<int>> countLocations(CountLocationsUsecaseParams params);
  Future<ApiResponse<LocationModel>> getLocationByCode(
    GetLocationByCodeUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkLocationCodeExists(
    CheckLocationCodeExistsUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkLocationExists(
    CheckLocationExistsUsecaseParams params,
  );
  Future<ApiResponse<LocationModel>> getLocationById(
    GetLocationByIdUsecaseParams params,
  );
  Future<ApiResponse<LocationModel>> updateLocation(
    UpdateLocationUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteLocation(
    DeleteLocationUsecaseParams params,
  );
  Future<ApiResponse<BulkCreateLocationsResponse>> createManyLocations(
    BulkCreateLocationsParams params,
  );
  Future<ApiResponse<BulkDeleteResponse>> deleteManyLocations(
    BulkDeleteParams params,
  );
}

class LocationRemoteDatasourceImpl implements LocationRemoteDatasource {
  final DioClient _dioClient;

  LocationRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<LocationModel>> createLocation(
    CreateLocationUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createLocation,
        data: params.toMap(),
        fromJson: (json) => LocationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<LocationModel>> getLocations(
    GetLocationsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getLocations,
        queryParameters: params.toMap(),
        fromJson: (json) => LocationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<LocationStatisticsModel>> getLocationsStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getLocationsStatistics,
        fromJson: (json) => LocationStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<LocationModel>> getLocationsCursor(
    GetLocationsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getLocationsCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => LocationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countLocations(
    CountLocationsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countLocations,
        queryParameters: params.toMap(),
        fromJson: (json) => json as int,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<LocationModel>> getLocationByCode(
    GetLocationByCodeUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getLocationByCode(params.code),
        fromJson: (json) => LocationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkLocationCodeExists(
    CheckLocationCodeExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkLocationCodeExists(params.code),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkLocationExists(
    CheckLocationExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkLocationExists(params.id),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<LocationModel>> getLocationById(
    GetLocationByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getLocationById(params.id),
        fromJson: (json) => LocationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<LocationModel>> updateLocation(
    UpdateLocationUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.patch(
        ApiConstant.updateLocation(params.id),
        data: params.toMap(),
        fromJson: (json) => LocationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteLocation(
    DeleteLocationUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteLocation(params.id),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<BulkCreateLocationsResponse>> createManyLocations(
    BulkCreateLocationsParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.bulkCreateLocations,
        data: params.toMap(),
        fromJson: (json) => BulkCreateLocationsResponse.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<BulkDeleteResponse>> deleteManyLocations(
    BulkDeleteParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.bulkDeleteLocations,
        data: params.toMap(),
        fromJson: (json) => BulkDeleteResponse.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
