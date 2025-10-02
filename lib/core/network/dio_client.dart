import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/interceptors/auth_interceptor.dart';
import 'package:sigma_track/core/network/interceptors/locale_interceptor.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/core/services/auth_service.dart';
import 'package:sigma_track/core/utils/logger.dart';

class DioClient {
  final Dio _dio;
  final LocaleInterceptor _localeInterceptor;
  final AuthInterceptor _authInterceptor;

  DioClient(this._dio, AuthService authService)
    : _localeInterceptor = LocaleInterceptor(),
      _authInterceptor = AuthInterceptor(authService) {
    _dio
      ..options.baseUrl = ApiConstant.baseUrl
      ..options.connectTimeout = const Duration(
        milliseconds: ApiConstant.defaultConnectTimeout,
      )
      ..options.receiveTimeout = const Duration(
        milliseconds: ApiConstant.defaultReceiveTimeout,
      )
      ..options.responseType = ResponseType.json
      ..options.headers = {'Accept': 'application/json'}
      ..interceptors.add(_localeInterceptor)
      ..interceptors.add(_authInterceptor);

    // Add Talker Dio Logger
    _dio.interceptors.add(logger.dioLogger);
  }

  // * Update bahasa
  void updateLocale(Locale locale) {
    _localeInterceptor.updateLocale(locale);
  }

  // * GET dengan single ApiResponse
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.data is String &&
          (response.data as String?)?.trim().startsWith('<!DOCTYPE html>') ==
              true) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'Server returned HTML instead of JSON. Check API endpoint: $path',
        );
      }

      return ApiResponse.fromMap(
        response.data as Map<String, dynamic>,
        fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // * GET dengan offset pagination
  Future<ApiOffsetPaginationResponse<T>> getWithOffset<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.data is String &&
          (response.data as String?)?.trim().startsWith('<!DOCTYPE html>') ==
              true) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'Server returned HTML instead of JSON. Check API endpoint: $path',
        );
      }

      return ApiOffsetPaginationResponse.fromMap(
        response.data as Map<String, dynamic>,
        fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // * GET dengan cursor pagination
  Future<ApiCursorPaginationResponse<T>> getWithCursor<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      if (response.data is String &&
          (response.data as String?)?.trim().startsWith('<!DOCTYPE html>') ==
              true) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message:
              'Server returned HTML instead of JSON. Check API endpoint: $path',
        );
      }

      return ApiCursorPaginationResponse.fromMap(
        response.data as Map<String, dynamic>,
        fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // * POST method
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponse.fromMap(
        response.data as Map<String, dynamic>,
        fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // * PUT method
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponse.fromMap(
        response.data as Map<String, dynamic>,
        fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // * PATCH method
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponse.fromMap(
        response.data as Map<String, dynamic>,
        fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // * DELETE method
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponse.fromMap(
        response.data as Map<String, dynamic>,
        fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // * Error handling
  ApiErrorResponse _handleError(DioException error) {
    final errorMessage = error.message ?? 'Network error occurred';

    if (error.response != null && error.response!.data != null) {
      try {
        if (error.response!.data is String &&
            (error.response!.data as String?)?.trim().startsWith(
                  '<!DOCTYPE html>',
                ) ==
                true) {
          return const ApiErrorResponse(
            status: 'error',
            message:
                'Server returned HTML instead of JSON. Check API endpoint configuration.',
          );
        }

        return ApiErrorResponse.fromMap(
          error.response!.data as Map<String, dynamic>,
        );
      } catch (e) {
        return ApiErrorResponse(
          status: 'error',
          message: error.response!.statusMessage ?? 'Unknown error occurred',
        );
      }
    } else {
      return ApiErrorResponse(status: 'error', message: errorMessage);
    }
  }
}
