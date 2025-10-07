import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification_statistics.dart';

// * State untuk getNotificationsStatistics usecase
class NotificationStatisticsState extends Equatable {
  final NotificationStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const NotificationStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory NotificationStatisticsState.initial() =>
      const NotificationStatisticsState(isLoading: true);

  factory NotificationStatisticsState.loading() =>
      const NotificationStatisticsState(isLoading: true);

  factory NotificationStatisticsState.success(
    NotificationStatistics statistics,
  ) => NotificationStatisticsState(statistics: statistics);

  factory NotificationStatisticsState.error(Failure failure) =>
      NotificationStatisticsState(failure: failure);

  NotificationStatisticsState copyWith({
    NotificationStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return NotificationStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
