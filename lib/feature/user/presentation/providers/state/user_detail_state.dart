import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

// * State untuk single user (getById, getByEmail, getByName, getCurrentUser)
class UserDetailState extends Equatable {
  final User? user;
  final bool isLoading;
  final Failure? failure;
  final String? message;

  const UserDetailState({
    this.user,
    this.isLoading = false,
    this.failure,
    this.message,
  });

  factory UserDetailState.initial() => const UserDetailState(isLoading: true);

  factory UserDetailState.loading() => const UserDetailState(isLoading: true);

  factory UserDetailState.success(User user, {String? message}) =>
      UserDetailState(user: user, message: message);

  factory UserDetailState.error(Failure failure) =>
      UserDetailState(failure: failure);

  UserDetailState copyWith({
    User? user,
    bool? isLoading,
    Failure? failure,
    String? message,
  }) {
    return UserDetailState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, failure, message];
}
