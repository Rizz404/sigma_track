import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk usecase yang return bool (checkExists)
class NotificationBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const NotificationBooleanState({
    this.result,
    this.isLoading = false,
    this.failure,
  });

  factory NotificationBooleanState.initial() =>
      const NotificationBooleanState(isLoading: true);

  factory NotificationBooleanState.loading() =>
      const NotificationBooleanState(isLoading: true);

  factory NotificationBooleanState.success(bool result) =>
      NotificationBooleanState(result: result);

  factory NotificationBooleanState.error(Failure failure) =>
      NotificationBooleanState(failure: failure);

  NotificationBooleanState copyWith({
    bool? result,
    bool? isLoading,
    Failure? failure,
  }) {
    return NotificationBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
