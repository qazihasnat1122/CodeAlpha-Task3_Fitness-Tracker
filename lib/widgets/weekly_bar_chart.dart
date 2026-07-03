// lib/widgets/weekly_bar_chart.dart
// Bar chart showing total calories burned per day this week using fl_chart.

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class WeeklyBarChart extends StatefulWidget {
  /// Map of {weekday index (0=Mon) → calories}.
  final Map<int, double> caloriesPerDay;
  final double height;

  const WeeklyBarChart({
    super.key,
    required this.caloriesPerDay,
    this.height = 160,
  });

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart>
    with SingleTickerProviderStateMixin {
  int _touchedIndex = -1;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  double get _maxY {
    final max = widget.caloriesPerDay.values.fold<double>(0, (m, v) => v > m ? v : m);
    return max < 100 ? 500 : (max * 1.3).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) {
        return Transform.scale(
          scaleY: _scaleAnim.value,
          alignment: Alignment.bottomCenter,
          child: child,
        );
      },
      child: SizedBox(
        height: widget.height,
        child: BarChart(
          BarChartData(
            maxY: _maxY,
            minY: 0,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => AppColors.textPrimary,
                tooltipRoundedRadius: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.toInt()} kcal',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                },
              ),
              touchCallback: (event, response) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.spot == null) {
                    _touchedIndex = -1;
                    return;
                  }
                  _touchedIndex = response.spot!.touchedBarGroupIndex;
                });
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= AppStrings.daysShort.length) {
                      return const SizedBox.shrink();
                    }
                    final isTouched = index == _touchedIndex;
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        AppStrings.daysShort[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isTouched ? FontWeight.w700 : FontWeight.w500,
                          color: isTouched
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
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
              horizontalInterval: _maxY / 4,
              getDrawingHorizontalLine: (_) => const FlLine(
                color: AppColors.border,
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(7, (index) {
              final calories = widget.caloriesPerDay[index] ?? 0;
              final isTouched = index == _touchedIndex;
              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: calories,
                    color: isTouched
                        ? AppColors.primaryDark
                        : AppColors.chartColors[index % AppColors.chartColors.length],
                    width: 22,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: _maxY,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
