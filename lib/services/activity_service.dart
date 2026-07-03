// lib/services/activity_service.dart
// Business logic layer between the Provider and DatabaseHelper.
// Handles summary calculations and delegates DB calls.

import '../database/database_helper.dart';
import '../models/fitness_activity.dart';
import '../utils/date_utils.dart';

/// Summary data for a specific time period (day or week).
class ActivitySummary {
  final int workoutCount;    // Number of activities
  final int totalDuration;   // Total minutes
  final int totalCalories;   // Total calories burned

  const ActivitySummary({
    required this.workoutCount,
    required this.totalDuration,
    required this.totalCalories,
  });

  /// An empty summary (zero values) — used as the default state.
  factory ActivitySummary.empty() => const ActivitySummary(
        workoutCount: 0,
        totalDuration: 0,
        totalCalories: 0,
      );
}

/// Weekly summary adds progress percentage on top of ActivitySummary.
class WeeklySummary extends ActivitySummary {
  final double progressPercentage; // 0.0 to 1.0

  const WeeklySummary({
    required super.workoutCount,
    required super.totalDuration,
    required super.totalCalories,
    required this.progressPercentage,
  });

  factory WeeklySummary.empty() => const WeeklySummary(
        workoutCount: 0,
        totalDuration: 0,
        totalCalories: 0,
        progressPercentage: 0.0,
      );
}

class ActivityService {
  final DatabaseHelper _db = DatabaseHelper.instance;

  // --- Weekly Goal Constants ---
  static const int weeklyCalorieGoal = 2500; // kcal goal for the week

  // =========================================================
  // CRUD Delegates
  // =========================================================

  Future<int> addActivity(FitnessActivity activity) =>
      _db.insertActivity(activity);

  Future<List<FitnessActivity>> fetchAllActivities() =>
      _db.getAllActivities();

  Future<int> updateActivity(FitnessActivity activity) =>
      _db.updateActivity(activity);

  Future<int> deleteActivity(int id) => _db.deleteActivity(id);

  // =========================================================
  // Summary Calculations
  // =========================================================

  /// Computes the summary for today from a pre-loaded list.
  ActivitySummary getDailySummary(List<FitnessActivity> activities) {
    final today = FitnessDateUtils.dateOnly(DateTime.now());
    final todaysActivities = activities
        .where((a) => FitnessDateUtils.dateOnly(a.date) == today)
        .toList();

    return _computeSummary(todaysActivities);
  }

  /// Computes the weekly summary from a pre-loaded list.
  WeeklySummary getWeeklySummary(List<FitnessActivity> activities) {
    final thisWeekActivities =
        activities.where((a) => FitnessDateUtils.isThisWeek(a.date)).toList();

    final base = _computeSummary(thisWeekActivities);
    final progress =
        (base.totalCalories / weeklyCalorieGoal).clamp(0.0, 1.0);

    return WeeklySummary(
      workoutCount: base.workoutCount,
      totalDuration: base.totalDuration,
      totalCalories: base.totalCalories,
      progressPercentage: progress,
    );
  }

  /// Returns a map of {weekday index (0=Mon) → total calories}
  /// for the current week, used to populate the bar chart.
  Map<int, double> getWeeklyCaloriesPerDay(List<FitnessActivity> activities) {
    final weekDays = FitnessDateUtils.currentWeekDays();
    final Map<int, double> result = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};

    for (final activity in activities) {
      if (!FitnessDateUtils.isThisWeek(activity.date)) continue;
      final dayDate = FitnessDateUtils.dateOnly(activity.date);
      for (int i = 0; i < weekDays.length; i++) {
        if (dayDate == weekDays[i]) {
          result[i] = (result[i] ?? 0) + activity.calories;
          break;
        }
      }
    }
    return result;
  }

  // =========================================================
  // Private Helpers
  // =========================================================

  ActivitySummary _computeSummary(List<FitnessActivity> activities) {
    if (activities.isEmpty) return ActivitySummary.empty();

    final totalDuration =
        activities.fold<int>(0, (sum, a) => sum + a.duration);
    final totalCalories =
        activities.fold<int>(0, (sum, a) => sum + a.calories);

    return ActivitySummary(
      workoutCount: activities.length,
      totalDuration: totalDuration,
      totalCalories: totalCalories,
    );
  }
}
