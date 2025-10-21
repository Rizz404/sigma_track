import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_statistics.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/asset_movement_providers.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/issue_report_providers.dart';
import 'package:sigma_track/feature/location/presentation/providers/location_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_providers.dart';
import 'package:sigma_track/feature/notification/presentation/providers/notification_providers.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_log_providers.dart';
import 'package:sigma_track/feature/user/domain/entities/user_statistics.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Todo: Masih belum akurat datanya nanti benerin lagi
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStats = ref.watch(userStatisticsProvider);
    final assetStats = ref.watch(assetStatisticsProvider);
    final categoryStats = ref.watch(categoryStatisticsProvider);
    final locationStats = ref.watch(locationStatisticsProvider);
    final scanLogStats = ref.watch(scanLogStatisticsProvider);
    final notificationStats = ref.watch(notificationStatisticsProvider);
    final assetMovementStats = ref.watch(getAssetMovementsStatisticsProvider);
    final issueReportStats = ref.watch(getIssueReportsStatisticsProvider);
    final maintenanceScheduleStats = ref.watch(
      getMaintenanceSchedulesStatisticsProvider,
    );
    final maintenanceRecordStats = ref.watch(
      getMaintenanceRecordsStatisticsProvider,
    );

    if (userStats.failure != null) {
      this.logError('User stats error', userStats.failure);
    }
    if (assetStats.failure != null) {
      this.logError('Asset stats error', assetStats.failure);
    }

    return Scaffold(
      body: ScreenWrapper(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              ref.read(userStatisticsProvider.notifier).refresh(),
              ref.read(assetStatisticsProvider.notifier).refresh(),
              ref.read(categoryStatisticsProvider.notifier).refresh(),
              ref.read(locationStatisticsProvider.notifier).refresh(),
              ref.read(scanLogStatisticsProvider.notifier).refresh(),
              ref.read(notificationStatisticsProvider.notifier).refresh(),
              // ! Skip refresh for providers without refresh method
              // ref.read(getAssetMovementsStatisticsProvider.notifier).refresh(),
              // ref.read(getIssueReportsStatisticsProvider.notifier).refresh(),
              // ref.read(getMaintenanceSchedulesStatisticsProvider.notifier).refresh(),
              // ref.read(getMaintenanceRecordsStatisticsProvider.notifier).refresh(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(
                  context,
                  userStats: userStats.statistics,
                  assetStats: assetStats.statistics,
                  isUserLoading: userStats.isLoading,
                  isAssetLoading: assetStats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildAssetOverview(
                  context,
                  assetStats.statistics,
                  assetStats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildUserRoleDistribution(
                  context,
                  userStats.statistics,
                  userStats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildAssetStatusChart(
                  context,
                  assetStats.statistics,
                  assetStats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildAssetConditionChart(
                  context,
                  assetStats.statistics,
                  assetStats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildRegistrationTrends(
                  context,
                  userStats.statistics,
                  userStats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildAssetCreationTrends(
                  context,
                  assetStats.statistics,
                  assetStats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildCategoryLocationStats(
                  context,
                  categoryStats: categoryStats.statistics,
                  locationStats: locationStats.statistics,
                  isCategoryLoading: categoryStats.isLoading,
                  isLocationLoading: locationStats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildActivityStats(
                  context,
                  scanLogStats: scanLogStats.statistics,
                  notificationStats: notificationStats.statistics,
                  assetMovementStats: assetMovementStats.statistics,
                  issueReportStats: issueReportStats.statistics,
                  isScanLogLoading: scanLogStats.isLoading,
                  isNotificationLoading: notificationStats.isLoading,
                  isAssetMovementLoading: assetMovementStats.isLoading,
                  isIssueReportLoading: issueReportStats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildMaintenanceStats(
                  context,
                  scheduleStats: maintenanceScheduleStats.statistics,
                  recordStats: maintenanceRecordStats.statistics,
                  isScheduleLoading: maintenanceScheduleStats.isLoading,
                  isRecordLoading: maintenanceRecordStats.isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context, {
    dynamic userStats,
    dynamic assetStats,
    required bool isUserLoading,
    required bool isAssetLoading,
  }) {
    return Row(
      children: [
        Expanded(
          child: Skeletonizer(
            enabled: isUserLoading,
            child: _buildStatCard(
              context,
              title: 'Total Users',
              value: '${userStats?.total.count ?? 0}',
              icon: Icons.people,
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Skeletonizer(
            enabled: isAssetLoading,
            child: _buildStatCard(
              context,
              title: 'Total Assets',
              value: '${assetStats?.total.count ?? 0}',
              icon: Icons.inventory_2,
              color: context.colors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          AppText(
            value,
            style: AppTextStyle.headlineMedium,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          AppText(
            title,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildAssetOverview(
    BuildContext context,
    dynamic assetStats,
    bool isLoading,
  ) {
    final stats = assetStats ?? AssetStatistics.dummy();
    final sections = [
      _PieSection(
        'Active',
        stats.byStatus.active.toDouble(),
        context.semantic.success,
      ),
      _PieSection(
        'Maintenance',
        stats.byStatus.maintenance.toDouble(),
        context.semantic.warning,
      ),
      _PieSection(
        'Disposed',
        stats.byStatus.disposed.toDouble(),
        context.semantic.error,
      ),
      _PieSection(
        'Lost',
        stats.byStatus.lost.toDouble(),
        context.colors.textTertiary,
      ),
    ];

    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'Asset Status Overview',
        child: SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: sections
                  .map(
                    (e) => PieChartSectionData(
                      value: e.value,
                      title: e.value > 0 ? '${e.value.toInt()}' : '',
                      color: e.color,
                      radius: 100,
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.colors.surface,
                      ),
                    ),
                  )
                  .toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
            ),
          ),
        ),
        legend: _buildLegend(context, sections),
      ),
    );
  }

  Widget _buildUserRoleDistribution(
    BuildContext context,
    dynamic userStats,
    bool isLoading,
  ) {
    final stats = userStats ?? UserStatistics.dummy();
    final sections = [
      _PieSection(
        'Admin',
        stats.byRole.admin.toDouble(),
        context.colors.primary,
      ),
      _PieSection(
        'Staff',
        stats.byRole.staff.toDouble(),
        context.colors.secondary,
      ),
      _PieSection(
        'Employee',
        stats.byRole.employee.toDouble(),
        context.semantic.info,
      ),
    ];

    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'User Role Distribution',
        child: SizedBox(
          height: 250,
          child: PieChart(
            PieChartData(
              sections: sections
                  .map(
                    (e) => PieChartSectionData(
                      value: e.value,
                      title: e.value > 0 ? '${e.value.toInt()}' : '',
                      color: e.color,
                      radius: 100,
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: context.colors.surface,
                      ),
                    ),
                  )
                  .toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 50,
            ),
          ),
        ),
        legend: _buildLegend(context, sections),
      ),
    );
  }

  Widget _buildAssetStatusChart(
    BuildContext context,
    dynamic assetStats,
    bool isLoading,
  ) {
    final stats = assetStats ?? AssetStatistics.dummy();

    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'Asset Status Breakdown',
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxValue([
                stats.byStatus.active.toDouble(),
                stats.byStatus.maintenance.toDouble(),
                stats.byStatus.disposed.toDouble(),
                stats.byStatus.lost.toDouble(),
              ]),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toInt()}',
                      TextStyle(
                        color: context.colors.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const titles = [
                        'Active',
                        'Maintenance',
                        'Disposed',
                        'Lost',
                      ];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AppText(
                          titles[value.toInt()],
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return AppText(
                        value.toInt().toString(),
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: context.colors.border, strokeWidth: 1);
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _buildBarGroup(
                  0,
                  stats.byStatus.active.toDouble(),
                  context.semantic.success,
                ),
                _buildBarGroup(
                  1,
                  stats.byStatus.maintenance.toDouble(),
                  context.semantic.warning,
                ),
                _buildBarGroup(
                  2,
                  stats.byStatus.disposed.toDouble(),
                  context.semantic.error,
                ),
                _buildBarGroup(
                  3,
                  stats.byStatus.lost.toDouble(),
                  context.colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetConditionChart(
    BuildContext context,
    dynamic assetStats,
    bool isLoading,
  ) {
    final stats = assetStats ?? AssetStatistics.dummy();

    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'Asset Condition Overview',
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxValue([
                stats.byCondition.good.toDouble(),
                stats.byCondition.fair.toDouble(),
                stats.byCondition.poor.toDouble(),
                stats.byCondition.damaged.toDouble(),
              ]),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${rod.toY.toInt()}',
                      TextStyle(
                        color: context.colors.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const titles = ['Good', 'Fair', 'Poor', 'Damaged'];
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AppText(
                          titles[value.toInt()],
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return AppText(
                        value.toInt().toString(),
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: context.colors.border, strokeWidth: 1);
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _buildBarGroup(
                  0,
                  stats.byCondition.good.toDouble(),
                  context.semantic.success,
                ),
                _buildBarGroup(
                  1,
                  stats.byCondition.fair.toDouble(),
                  context.semantic.warning,
                ),
                _buildBarGroup(
                  2,
                  stats.byCondition.poor.toDouble(),
                  Colors.orange,
                ),
                _buildBarGroup(
                  3,
                  stats.byCondition.damaged.toDouble(),
                  context.semantic.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationTrends(
    BuildContext context,
    dynamic userStats,
    bool isLoading,
  ) {
    if (userStats == null || userStats.registrationTrends.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = userStats.registrationTrends
        .asMap()
        .entries
        .map<FlSpot>((e) => FlSpot(e.key.toDouble(), e.value.count.toDouble()))
        .toList();

    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'User Registration Trends',
        child: SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: context.colors.border, strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >=
                          userStats.registrationTrends.length) {
                        return const SizedBox.shrink();
                      }
                      final date =
                          userStats.registrationTrends[value.toInt()].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AppText(
                          '${date.month}/${date.day}',
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return AppText(
                        value.toInt().toString(),
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: context.colors.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        context.colors.primary.withValues(alpha: 0.3),
                        context.colors.primary.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetCreationTrends(
    BuildContext context,
    dynamic assetStats,
    bool isLoading,
  ) {
    if (assetStats == null || assetStats.creationTrends.isEmpty) {
      return const SizedBox.shrink();
    }

    final spots = assetStats.creationTrends
        .asMap()
        .entries
        .map<FlSpot>((e) => FlSpot(e.key.toDouble(), e.value.count.toDouble()))
        .toList();

    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'Asset Creation Trends',
        child: SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(color: context.colors.border, strokeWidth: 1);
                },
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= assetStats.creationTrends.length) {
                        return const SizedBox.shrink();
                      }
                      final date =
                          assetStats.creationTrends[value.toInt()].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AppText(
                          '${date.month}/${date.day}',
                          style: AppTextStyle.bodySmall,
                          color: context.colors.textSecondary,
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return AppText(
                        value.toInt().toString(),
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: context.colors.secondary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        context.colors.secondary.withValues(alpha: 0.3),
                        context.colors.secondary.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryLocationStats(
    BuildContext context, {
    dynamic categoryStats,
    dynamic locationStats,
    required bool isCategoryLoading,
    required bool isLocationLoading,
  }) {
    return Row(
      children: [
        Expanded(
          child: Skeletonizer(
            enabled: isCategoryLoading,
            child: _buildInfoCard(
              context,
              title: 'Categories',
              value: '${categoryStats?.total.count ?? 0}',
              icon: Icons.category,
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Skeletonizer(
            enabled: isLocationLoading,
            child: _buildInfoCard(
              context,
              title: 'Locations',
              value: '${locationStats?.total.count ?? 0}',
              icon: Icons.location_on,
              color: context.colors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityStats(
    BuildContext context, {
    dynamic scanLogStats,
    dynamic notificationStats,
    dynamic assetMovementStats,
    dynamic issueReportStats,
    required bool isScanLogLoading,
    required bool isNotificationLoading,
    required bool isAssetMovementLoading,
    required bool isIssueReportLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Activity Overview',
          style: AppTextStyle.titleLarge,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Skeletonizer(
                enabled: isScanLogLoading,
                child: _buildInfoCard(
                  context,
                  title: 'Scan Logs',
                  value: '${scanLogStats?.total.count ?? 0}',
                  icon: Icons.qr_code_scanner,
                  color: context.semantic.info,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Skeletonizer(
                enabled: isNotificationLoading,
                child: _buildInfoCard(
                  context,
                  title: 'Notifications',
                  value: '${notificationStats?.total.count ?? 0}',
                  icon: Icons.notifications,
                  color: context.semantic.warning,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Skeletonizer(
                enabled: isAssetMovementLoading,
                child: _buildInfoCard(
                  context,
                  title: 'Asset Movements',
                  value: '${assetMovementStats?.total.count ?? 0}',
                  icon: Icons.swap_horiz,
                  color: context.semantic.info,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Skeletonizer(
                enabled: isIssueReportLoading,
                child: _buildInfoCard(
                  context,
                  title: 'Issue Reports',
                  value: '${issueReportStats?.total.count ?? 0}',
                  icon: Icons.report_problem,
                  color: context.semantic.error,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMaintenanceStats(
    BuildContext context, {
    dynamic scheduleStats,
    dynamic recordStats,
    required bool isScheduleLoading,
    required bool isRecordLoading,
  }) {
    return Row(
      children: [
        Expanded(
          child: Skeletonizer(
            enabled: isScheduleLoading,
            child: _buildInfoCard(
              context,
              title: 'Maintenance Schedules',
              value: '${scheduleStats?.total.count ?? 0}',
              icon: Icons.schedule,
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Skeletonizer(
            enabled: isRecordLoading,
            child: _buildInfoCard(
              context,
              title: 'Maintenance Records',
              value: '${recordStats?.total.count ?? 0}',
              icon: Icons.history,
              color: context.colors.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  value,
                  style: AppTextStyle.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 2),
                AppText(
                  title,
                  style: AppTextStyle.bodySmall,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard(
    BuildContext context, {
    required String title,
    required Widget child,
    Widget? legend,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            title,
            style: AppTextStyle.titleMedium,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 20),
          child,
          if (legend != null) ...[const SizedBox(height: 20), legend],
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context, List<_PieSection> sections) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: sections.map((section) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: section.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            AppText(
              '${section.label}: ${section.value.toInt()}',
              style: AppTextStyle.bodySmall,
              color: context.colors.textSecondary,
            ),
          ],
        );
      }).toList(),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ],
    );
  }

  double _getMaxValue(List<double> values) {
    if (values.isEmpty) return 10;
    final max = values.reduce((a, b) => a > b ? a : b);
    return max == 0 ? 10 : max + (max * 0.2);
  }
}

class _PieSection {
  final String label;
  final double value;
  final Color color;

  const _PieSection(this.label, this.value, this.color);
}
