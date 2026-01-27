import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/feature/user/domain/entities/user_personal_statistics.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userPersonalStatisticsNotifierProvider);

    if (stats.failure != null) {
      this.logError('Personal stats error', stats.failure);
    }

    return Scaffold(
      body: ScreenWrapper(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(userPersonalStatisticsNotifierProvider.notifier)
                .refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(context, stats.statistics, stats.isLoading),
                const SizedBox(height: 24),
                _buildAssetConditionPieChart(
                  context,
                  stats.statistics,
                  stats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildAssetConditionBarChart(
                  context,
                  stats.statistics,
                  stats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildIssueReportStatusChart(
                  context,
                  stats.statistics,
                  stats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildIssueReportPriorityChart(
                  context,
                  stats.statistics,
                  stats.isLoading,
                ),
                const SizedBox(height: 24),
                _buildSummaryInfo(context, stats.statistics, stats.isLoading),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    UserPersonalStatistics? stats,
    bool isLoading,
  ) {
    return Row(
      children: [
        Expanded(
          child: Skeletonizer(
            enabled: isLoading,
            child: _buildStatCard(
              context,
              title: 'Total Aset Saya',
              value: '${stats?.assets.total.count ?? 0}',
              icon: Icons.inventory_2,
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Skeletonizer(
            enabled: isLoading,
            child: _buildStatCard(
              context,
              title: 'Total Nilai Aset',
              value: 'Rp ${_formatNumber(stats?.assets.total.totalValue ?? 0)}',
              icon: Icons.attach_money,
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

  Widget _buildAssetConditionPieChart(
    BuildContext context,
    UserPersonalStatistics? stats,
    bool isLoading,
  ) {
    final sections = [
      _PieSection(
        'Baik',
        stats?.assets.byCondition.good.toDouble() ?? 0,
        context.semantic.success,
      ),
      _PieSection(
        'Cukup',
        stats?.assets.byCondition.fair.toDouble() ?? 0,
        context.semantic.warning,
      ),
      _PieSection(
        'Buruk',
        stats?.assets.byCondition.poor.toDouble() ?? 0,
        context.semantic.warning,
      ),
      _PieSection(
        'Rusak',
        stats?.assets.byCondition.damaged.toDouble() ?? 0,
        context.semantic.error,
      ),
    ];

    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'Kondisi Aset Saya',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
        ),
        legend: _buildLegend(context, sections),
      ),
    );
  }

  Widget _buildAssetConditionBarChart(
    BuildContext context,
    UserPersonalStatistics? stats,
    bool isLoading,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'Detail Kondisi Aset',
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxValue([
                stats?.assets.byCondition.good.toDouble() ?? 0,
                stats?.assets.byCondition.fair.toDouble() ?? 0,
                stats?.assets.byCondition.poor.toDouble() ?? 0,
                stats?.assets.byCondition.damaged.toDouble() ?? 0,
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
                      final conditions = AssetCondition.values;
                      if (value.toInt() >= conditions.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AppText(
                          conditions[value.toInt()].label,
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
                  stats?.assets.byCondition.good.toDouble() ?? 0,
                  context.semantic.success,
                ),
                _buildBarGroup(
                  1,
                  stats?.assets.byCondition.fair.toDouble() ?? 0,
                  context.semantic.warning,
                ),
                _buildBarGroup(
                  2,
                  stats?.assets.byCondition.poor.toDouble() ?? 0,
                  context.semantic.warning,
                ),
                _buildBarGroup(
                  3,
                  stats?.assets.byCondition.damaged.toDouble() ?? 0,
                  context.semantic.error,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIssueReportStatusChart(
    BuildContext context,
    UserPersonalStatistics? stats,
    bool isLoading,
  ) {
    final sections = [
      _PieSection(
        'Terbuka',
        stats?.issueReports.byStatus.open.toDouble() ?? 0,
        context.semantic.error,
      ),
      _PieSection(
        'Dalam Proses',
        stats?.issueReports.byStatus.inProgress.toDouble() ?? 0,
        context.semantic.warning,
      ),
      _PieSection(
        'Terselesaikan',
        stats?.issueReports.byStatus.resolved.toDouble() ?? 0,
        context.semantic.success,
      ),
      _PieSection(
        'Ditutup',
        stats?.issueReports.byStatus.closed.toDouble() ?? 0,
        context.colors.textSecondary,
      ),
    ];

    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'Status Laporan Masalah Saya',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
        ),
        legend: _buildLegend(context, sections),
      ),
    );
  }

  Widget _buildIssueReportPriorityChart(
    BuildContext context,
    UserPersonalStatistics? stats,
    bool isLoading,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: _buildChartCard(
        context,
        title: 'Prioritas Laporan Masalah',
        child: SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _getMaxValue([
                stats?.issueReports.byPriority.high.toDouble() ?? 0,
                stats?.issueReports.byPriority.medium.toDouble() ?? 0,
                stats?.issueReports.byPriority.low.toDouble() ?? 0,
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
                      final labels = ['Tinggi', 'Sedang', 'Rendah'];
                      if (value.toInt() >= labels.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: AppText(
                          labels[value.toInt()],
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
                  stats?.issueReports.byPriority.high.toDouble() ?? 0,
                  context.semantic.error,
                ),
                _buildBarGroup(
                  1,
                  stats?.issueReports.byPriority.medium.toDouble() ?? 0,
                  context.semantic.warning,
                ),
                _buildBarGroup(
                  2,
                  stats?.issueReports.byPriority.low.toDouble() ?? 0,
                  context.semantic.info,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryInfo(
    BuildContext context,
    UserPersonalStatistics? stats,
    bool isLoading,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  title: 'Health Score',
                  value: '${stats?.summary.healthScore ?? 0}',
                  icon: Icons.favorite,
                  color: _getHealthScoreColor(
                    context,
                    stats?.summary.healthScore ?? 0,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  context,
                  title: 'Laporan Aktif',
                  value: stats?.summary.hasActiveIssues == true
                      ? 'Ya'
                      : 'Tidak',
                  icon: Icons.warning_amber,
                  color: stats?.summary.hasActiveIssues == true
                      ? context.semantic.warning
                      : context.semantic.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  title: 'Usia Akun',
                  value: stats?.summary.accountAge ?? '-',
                  icon: Icons.calendar_today,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  context,
                  title: 'Total Laporan',
                  value: '${stats?.issueReports.total.count ?? 0}',
                  icon: Icons.report,
                  color: context.colors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
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
            style: AppTextStyle.titleLarge,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          child,
          if (legend != null) ...[const SizedBox(height: 16), legend],
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
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: section.color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
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
    final max = values.reduce((a, b) => a > b ? a : b);
    return max == 0 ? 10 : max * 1.2;
  }

  Color _getHealthScoreColor(BuildContext context, int score) {
    if (score >= 80) return context.semantic.success;
    if (score >= 50) return context.semantic.warning;
    return context.semantic.error;
  }

  String _formatNumber(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}M';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}Jt';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}Rb';
    }
    return value.toStringAsFixed(0);
  }
}

class _PieSection {
  final String label;
  final double value;
  final Color color;

  const _PieSection(this.label, this.value, this.color);
}
