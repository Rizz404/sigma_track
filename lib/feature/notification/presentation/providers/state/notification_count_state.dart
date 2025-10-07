import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';

// * State untuk countNotifications usecase
class NotificationCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const NotificationCountState({
    this.count,
    this.isLoading = false,
    this.failure,
  });

  factory NotificationCountState.initial() =>
      const NotificationCountState(isLoading: true);

  factory NotificationCountState.loading() =>
      const NotificationCountState(isLoading: true);

  factory NotificationCountState.success(int count) =>
      NotificationCountState(count: count);

  factory NotificationCountState.error(Failure failure) =>
      NotificationCountState(failure: failure);

  NotificationCountState copyWith({
    int? count,
    bool? isLoading,
    Failure? failure,
  }) {
    return NotificationCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
