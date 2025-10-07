import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk usecase yang return bool (checkExists, checkEmailExists, checkNameExists)
class UserBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const UserBooleanState({this.result, this.isLoading = false, this.failure});

  factory UserBooleanState.initial() => const UserBooleanState(isLoading: true);

  factory UserBooleanState.loading() => const UserBooleanState(isLoading: true);

  factory UserBooleanState.success(bool result) =>
      UserBooleanState(result: result);

  factory UserBooleanState.error(Failure failure) =>
      UserBooleanState(failure: failure);

  UserBooleanState copyWith({bool? result, bool? isLoading, Failure? failure}) {
    return UserBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
