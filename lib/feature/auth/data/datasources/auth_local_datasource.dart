import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigma_track/core/constants/storage_key_constant.dart';
import 'package:sigma_track/core/utils/logger.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

abstract class AuthLocalDatasource {
  Future<String?> getAccessToken();
  Future<void> saveAccessToken(String token);
  Future<void> deleteAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveRefreshToken(String token);
  Future<void> deleteRefreshToken();

  // * UserModel
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final FlutterSecureStorage _flutterSecureStorage;
  final SharedPreferencesWithCache _sharedPreferencesWithCache;

  AuthLocalDatasourceImpl(
    this._flutterSecureStorage,
    this._sharedPreferencesWithCache,
  );

  @override
  Future<String?> getAccessToken() async {
    final token = await _flutterSecureStorage.read(
      key: StorageKeyConstant.accessTokenKey,
    );
    logger.logData(
      'GET accessToken: ${token != null ? 'Token exists' : 'No token'}',
    );
    return token;
  }

  @override
  Future<void> saveAccessToken(String token) async {
    await _flutterSecureStorage.write(
      key: StorageKeyConstant.accessTokenKey,
      value: token,
    );
    logger.logData('SAVE accessToken: Token saved successfully');
  }

  @override
  Future<void> deleteAccessToken() async {
    await _flutterSecureStorage.delete(key: StorageKeyConstant.accessTokenKey);
    logger.logData('DELETE accessToken');
  }

  @override
  Future<String?> getRefreshToken() async {
    final token = await _flutterSecureStorage.read(
      key: StorageKeyConstant.refreshTokenKey,
    );
    logger.logData(
      'GET refreshToken: ${token != null ? 'Token exists' : 'No token'}',
    );
    return token;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    await _flutterSecureStorage.write(
      key: StorageKeyConstant.refreshTokenKey,
      value: token,
    );
    logger.logData('SAVE refreshToken: Token saved successfully');
  }

  @override
  Future<void> deleteRefreshToken() async {
    await _flutterSecureStorage.delete(key: StorageKeyConstant.refreshTokenKey);
    logger.logData('DELETE refreshToken');
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = await _sharedPreferencesWithCache.getString(
      StorageKeyConstant.userKey,
    );

    if (userJson != null) {
      final userModelJson = UserModel.fromJson(jsonDecode(userJson));
      logger.logData('GET user: UserModel found: ${userModelJson.name}');
      return userModelJson;
    }

    logger.logData('GET user: No user found');
    return null;
  }

  @override
  Future<void> saveUser(UserModel userModel) async {
    await _sharedPreferencesWithCache.setString(
      StorageKeyConstant.userKey,
      jsonEncode(userModel.toJson()),
    );
    logger.logData('SAVE user: UserModel saved: ${userModel.name}');
  }

  @override
  Future<void> deleteUser() async {
    await _sharedPreferencesWithCache.remove(StorageKeyConstant.userKey);
    logger.logData('DELETE user');
  }
}
