import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/user/domain/entities/user_statistics.dart';

// * State untuk getUsersStatistics usecase
class UserStatisticsState extends Equatable {
  final UserStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const UserStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory UserStatisticsState.initial() =>
      const UserStatisticsState(isLoading: true);

  factory UserStatisticsState.loading() =>
      const UserStatisticsState(isLoading: true);

  factory UserStatisticsState.success(UserStatistics statistics) =>
      UserStatisticsState(statistics: statistics);

  factory UserStatisticsState.error(Failure failure) =>
      UserStatisticsState(failure: failure);

  UserStatisticsState copyWith({
    UserStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return UserStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
