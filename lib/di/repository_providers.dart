import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/di/datasource_providers.dart';
import 'package:sigma_track/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final _authRemoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final _authLocalDatasource = ref.watch(authLocalDatasourceProvider);
  return AuthRepositoryImpl(_authRemoteDatasource, _authLocalDatasource);
});
