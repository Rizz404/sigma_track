import 'dart:convert';

import 'package:sigma_track/core/constants/storage_key_constant.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sigma_track/core/utils/logger.dart';

abstract class SessionStorageService {
  Future<String?> getAccessToken();
  Future<void> saveAccessToken(String token);
  Future<void> deleteAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveRefreshToken(String token);
  Future<void> deleteRefreshToken();

  // * User
  Future<User?> getUser();
  Future<void> saveUser(User user);
  Future<void> deleteUser();
}

class SessionStorageServiceImpl implements SessionStorageService {
  final FlutterSecureStorage _flutterSecureStorage;
  final SharedPreferencesWithCache _sharedPreferencesWithCache;

  SessionStorageServiceImpl(
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
  Future<User?> getUser() async {
    final userJson = await _sharedPreferencesWithCache.getString(
      StorageKeyConstant.userKey,
    );

    if (userJson != null) {
      final userModelJson = UserModel.fromJson(jsonDecode(userJson));
      final user = userModelJson.toEntity();
      logger.logData('GET user: User found: ${user.name}');
      return user;
    }

    logger.logData('GET user: No user found');
    return null;
  }

  @override
  Future<void> saveUser(User user) async {
    final userModel = user.toModel();
    await _sharedPreferencesWithCache.setString(
      StorageKeyConstant.userKey,
      jsonEncode(userModel.toJson()),
    );
    logger.logData('SAVE user: User saved: ${user.name}');
  }

  @override
  Future<void> deleteUser() async {
    await _sharedPreferencesWithCache.remove(StorageKeyConstant.userKey);
    logger.logData('DELETE user');
  }
}
