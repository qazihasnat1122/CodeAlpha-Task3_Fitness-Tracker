// lib/screens/dashboard_screen.dart
// Dashboard screen: Today's summary, weekly progress, bar chart.
// Uses Consumer to reactively rebuild only when ActivityProvider changes.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/activity_provider.dart';
import '../services/activity_service.dart';
import '../widgets/circular_progress_widget.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/weekly_bar_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ActivityProvider>(
        builder: (context, provider, _) {
          // Show a full-screen loader during initial data fetch
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final daily = provider.dailySummary;
          final weekly = provider.weeklySummary;
          final chartData = provider.weeklyCaloriesPerDay;

          return RefreshIndicator(
            onRefresh: () => provider.loadActivities(),
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // --- App Bar ---
                // ignore: prefer_const_constructors
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  expandedHeight: 80,
                  flexibleSpace: const FlexibleSpaceBar(
                    titlePadding:
                        EdgeInsets.fromLTRB(20, 0, 20, 16),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.dashboardTitle,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // === TODAY'S SUMMARY SECTION ===
                        const _SectionHeader(title: AppStrings.todaySummary),
                        const SizedBox(height: 12),

                        // 3-column stat grid
                        Row(
                          children: [
                            Expanded(
                              child: DashboardStatCard(
                                icon: Icons.fitness_center_rounded,
                                value: '${daily.workoutCount}',
                                label: AppStrings.totalWorkouts,
                                iconColor: AppColors.primary,
                                iconBackground: AppColors.primaryLight,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DashboardStatCard(
                                icon: Icons.timer_outlined,
                                value: '${daily.totalDuration}',
                                unit: AppStrings.minutes,
                                label: AppStrings.totalDuration,
                                iconColor: AppColors.accent,
                                iconBackground: AppColors.accentLight,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DashboardStatCard(
                                icon: Icons.local_fire_department_rounded,
                                value: '${daily.totalCalories}',
                                unit: AppStrings.kcal,
                                label: AppStrings.totalCalories,
                                iconColor: AppColors.colorRunning,
                                iconBackground:
                                    AppColors.colorRunning.withValues(alpha: 0.12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // === WEEKLY PROGRESS SECTION ===
                        const _SectionHeader(title: AppStrings.weeklyProgress),
                        const SizedBox(height: 12),

                        // Weekly summary card
                        _WeeklySummaryCard(weekly: weekly),
                        const SizedBox(height: 16),

                        // === WEEKLY CHART SECTION ===
                        const _SectionHeader(title: AppStrings.weeklyCaloriesChart),
                        const SizedBox(height: 12),

                        _ChartCard(chartData: chartData),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =============================================================
// Private Sub-Widgets
// =============================================================

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.2,
      ),
    );
  }
}

class _WeeklySummaryCard extends StatelessWidget {
  final WeeklySummary weekly;

  const _WeeklySummaryCard({required this.weekly});

  @override
  Widget build(BuildContext context) {
    final progressPercent = (weekly.progressPercentage * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular progress indicator
          CircularProgressWidget(
            progress: weekly.progressPercentage,
            centerLabel: '$progressPercent%',
            subLabel: 'of weekly\ngoal',
            size: 120,
            progressColor: Colors.white,
            trackColor: Colors.white.withValues(alpha: 0.25),
            strokeWidth: 9,
          ),
          const SizedBox(width: 20),

          // Weekly stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _WeeklyStatRow(
                  icon: Icons.fitness_center_rounded,
                  label: AppStrings.workoutsThisWeek,
                  value: '${weekly.workoutCount}',
                ),
                const SizedBox(height: 14),
                _WeeklyStatRow(
                  icon: Icons.timer_outlined,
                  label: AppStrings.minutesThisWeek,
                  value: '${weekly.totalDuration} min',
                ),
                const SizedBox(height: 14),
                _WeeklyStatRow(
                  icon: Icons.local_fire_department_rounded,
                  label: AppStrings.caloriesThisWeek,
                  value: '${weekly.totalCalories} kcal',
                ),
                const SizedBox(height: 14),
                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.weeklyGoal,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${ActivityService.weeklyCalorieGoal} kcal',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: weekly.progressPercentage,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeeklyStatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.8)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  final Map<int, double> chartData;

  const _ChartCard({required this.chartData});

  @override
  Widget build(BuildContext context) {
    final hasData = chartData.values.any((v) => v > 0);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: hasData
          ? WeeklyBarChart(caloriesPerDay: chartData)
          : const SizedBox(
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_rounded,
                      size: 40, color: AppColors.textHint),
                  SizedBox(height: 8),
                  Text(
                    'No workouts logged this week',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
