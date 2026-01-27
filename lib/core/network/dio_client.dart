import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/interceptors/auth_interceptor.dart';
import 'package:sigma_track/core/network/interceptors/locale_interceptor.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/l10n/app_localizations.dart';
import 'package:sigma_track/core/network/interceptors/network_error_interceptor.dart';
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
  final NetworkErrorInterceptor _networkErrorInterceptor;

  DioClient(
    this._dio,
    AuthService authService, {
    void Function()? onTokenInvalid,
  }) : _localeInterceptor = LocaleInterceptor(),
       _authInterceptor = AuthInterceptor(
         authService,
         onTokenInvalid: onTokenInvalid,
       ),
       _networkErrorInterceptor = NetworkErrorInterceptor() {
    // ! Dari bot, nanti rungkat salahin ini
    _dio.interceptors.clear();
    _dio
      ..options.baseUrl = ApiConstant.baseUrl
      ..options.connectTimeout = const Duration(
        milliseconds: ApiConstant.defaultConnectTimeout,
      )
      ..options.receiveTimeout = const Duration(
        milliseconds: ApiConstant.defaultReceiveTimeout, // * 3 minutes default
      )
      ..options.responseType = ResponseType.json
      ..options.headers = {
        'Accept': 'application/json',
        'X-API-Key': ApiConstant.apiKey,
      }
      ..interceptors.add(_localeInterceptor)
      ..interceptors.add(_authInterceptor)
      ..interceptors.add(_networkErrorInterceptor);

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
          message: (() {
            try {
              return LocalizationExtension.current.networkErrorHtmlResponse;
            } catch (_) {
              return 'Server returned HTML instead of JSON. Check API endpoint: $path';
            }
          })(),
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
          message: (() {
            try {
              return LocalizationExtension.current.networkErrorHtmlResponse;
            } catch (_) {
              return 'Server returned HTML instead of JSON. Check API endpoint: $path';
            }
          })(),
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
          message: (() {
            try {
              return LocalizationExtension.current.networkErrorHtmlResponse;
            } catch (_) {
              return 'Server returned HTML instead of JSON. Check API endpoint: $path';
            }
          })(),
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

  // * POST method untuk binary response (file download)
  Future<ApiResponse<T>> postForBinary<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    required T Function(dynamic data) fromData,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      // * Untuk binary response, langsung return data tanpa parse JSON
      return ApiResponse<T>(
        status: 'success',
        message: (() {
          try {
            return LocalizationExtension.current.networkErrorFileDownloaded;
          } catch (_) {
            return 'File downloaded successfully';
          }
        })(),
        data: fromData(response.data),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // * Error handling
  ApiErrorResponse _handleError(DioException error) {
    final errorMessage = error.message ?? 'Network error occurred';

    // Helper to get l10n string safely
    String getL10nString(String Function(L10n) callback, String fallback) {
      try {
        final l10n = LocalizationExtension.current;
        return callback(l10n);
      } catch (_) {
        return fallback;
      }
    }

    if (error.response != null && error.response!.data != null) {
      try {
        if (error.response!.data is String &&
            (error.response!.data as String?)?.trim().startsWith(
                  '<!DOCTYPE html>',
                ) ==
                true) {
          return ApiErrorResponse(
            status: 'error',
            message: getL10nString(
              (l) => l.networkErrorHtmlResponse,
              'Server returned HTML instead of JSON. Check API endpoint configuration.',
            ),
          );
        }

        return ApiErrorResponse.fromMap(
          error.response!.data as Map<String, dynamic>,
        );
      } catch (e) {
        return ApiErrorResponse(
          status: 'error',
          message:
              error.response!.statusMessage ??
              getL10nString(
                (l) => l.networkErrorUnknown,
                'Unknown error occurred',
              ),
        );
      }
    } else {
      return ApiErrorResponse(status: 'error', message: errorMessage);
    }
  }
}
