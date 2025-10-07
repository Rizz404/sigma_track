import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk countUsers usecase
class UserCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const UserCountState({this.count, this.isLoading = false, this.failure});

  factory UserCountState.initial() => const UserCountState(isLoading: true);

  factory UserCountState.loading() => const UserCountState(isLoading: true);

  factory UserCountState.success(int count) => UserCountState(count: count);

  factory UserCountState.error(Failure failure) =>
      UserCountState(failure: failure);

  UserCountState copyWith({int? count, bool? isLoading, Failure? failure}) {
    return UserCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
