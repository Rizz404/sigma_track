import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/di/common_providers.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sigma_track/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final _dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDatasourceImpl(_dioClient);
});

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final _sharedPreferencesWithCache = ref.watch(
    sharedPreferencesWithCacheProvider,
  );
  final _flutterSecureStorage = ref.watch(secureStorageProvider);
  return AuthLocalDatasourceImpl(
    _flutterSecureStorage,
    _sharedPreferencesWithCache,
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final _authRemoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final _authLocalDatasource = ref.watch(authLocalDatasourceProvider);
  return AuthRepositoryImpl(_authRemoteDatasource, _authLocalDatasource);
});
