import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/user/domain/usecases/count_users_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/check_user_email_exists_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/check_user_exists_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/check_user_name_exists_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/count_users_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/get_current_user_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/get_user_by_email_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/get_user_by_id_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/get_user_by_name_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_statistics_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/users_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_boolean_state.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_count_state.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_detail_state.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_statistics_state.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/users_state.dart';

final usersProvider = AutoDisposeNotifierProvider<UsersNotifier, UsersState>(
  UsersNotifier.new,
);

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final usersSearchProvider =
    AutoDisposeNotifierProvider<UsersNotifier, UsersState>(UsersNotifier.new);

// * Provider untuk check apakah user email exists
final checkUserEmailExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckUserEmailExistsNotifier,
      UserBooleanState,
      String
    >(CheckUserEmailExistsNotifier.new);

// * Provider untuk check apakah user exists by ID
final checkUserExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckUserExistsNotifier,
      UserBooleanState,
      String
    >(CheckUserExistsNotifier.new);

// * Provider untuk check apakah user name exists
final checkUserNameExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckUserNameExistsNotifier,
      UserBooleanState,
      String
    >(CheckUserNameExistsNotifier.new);

// * Provider untuk count users
final countUsersProvider =
    AutoDisposeNotifierProviderFamily<
      CountUsersNotifier,
      UserCountState,
      CountUsersUsecaseParams
    >(CountUsersNotifier.new);

// * Provider untuk get current user
final getCurrentUserProvider =
    AutoDisposeNotifierProvider<
      GetCurrentUserNotifier,
      UserDetailState
    >(GetCurrentUserNotifier.new);

// * Provider untuk get user by email
final getUserByEmailProvider =
    AutoDisposeNotifierProviderFamily<
      GetUserByEmailNotifier,
      UserDetailState,
      String
    >(GetUserByEmailNotifier.new);

// * Provider untuk get user by ID
final getUserByIdProvider =
    AutoDisposeNotifierProviderFamily<
      GetUserByIdNotifier,
      UserDetailState,
      String
    >(GetUserByIdNotifier.new);

// * Provider untuk get user by name
final getUserByNameProvider =
    AutoDisposeNotifierProviderFamily<
      GetUserByNameNotifier,
      UserDetailState,
      String
    >(GetUserByNameNotifier.new);

// * Provider untuk user statistics
final userStatisticsProvider =
    AutoDisposeNotifierProvider<
      UserStatisticsNotifier,
      UserStatisticsState
    >(UserStatisticsNotifier.new);
