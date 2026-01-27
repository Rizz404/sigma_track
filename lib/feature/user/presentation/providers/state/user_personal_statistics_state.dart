import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/user/domain/entities/user_personal_statistics.dart';

// * State untuk getUserPersonalStatistics usecase
class UserPersonalStatisticsState extends Equatable {
  final UserPersonalStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const UserPersonalStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory UserPersonalStatisticsState.initial() =>
      const UserPersonalStatisticsState(isLoading: true);

  factory UserPersonalStatisticsState.loading() =>
      const UserPersonalStatisticsState(isLoading: true);

  factory UserPersonalStatisticsState.success(
    UserPersonalStatistics statistics,
  ) => UserPersonalStatisticsState(statistics: statistics);

  factory UserPersonalStatisticsState.error(Failure failure) =>
      UserPersonalStatisticsState(failure: failure);

  UserPersonalStatisticsState copyWith({
    UserPersonalStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return UserPersonalStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
