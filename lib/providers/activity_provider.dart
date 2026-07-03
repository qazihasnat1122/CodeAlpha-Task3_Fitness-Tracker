// lib/providers/activity_provider.dart
// ChangeNotifier provider — the single source of truth for app state.
// All UI reads data from here; all mutations go through here.

import 'package:flutter/foundation.dart';

import '../models/fitness_activity.dart';
import '../services/activity_service.dart';

/// Describes the current loading state of the provider.
enum ProviderState { initial, loading, loaded, error }

class ActivityProvider extends ChangeNotifier {
  final ActivityService _service = ActivityService();

  // --- State ---
  ProviderState _state = ProviderState.initial;
  List<FitnessActivity> _activities = [];
  String _errorMessage = '';

  // --- Getters ---
  ProviderState get state => _state;
  List<FitnessActivity> get activities => List.unmodifiable(_activities);
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == ProviderState.loading;

  /// Derived: today's summary (computed each time from the cached list).
  ActivitySummary get dailySummary => _service.getDailySummary(_activities);

  /// Derived: this week's summary (computed each time from the cached list).
  WeeklySummary get weeklySummary => _service.getWeeklySummary(_activities);

  /// Derived: calories per weekday for the chart.
  Map<int, double> get weeklyCaloriesPerDay =>
      _service.getWeeklyCaloriesPerDay(_activities);

  // =========================================================
  // Initialization
  // =========================================================

  /// Loads all activities from the database.
  /// Call once from the app startup (or screen initState).
  Future<void> loadActivities() async {
    _setState(ProviderState.loading);
    try {
      _activities = await _service.fetchAllActivities();
      _setState(ProviderState.loaded);
    } catch (e) {
      _errorMessage = 'Failed to load activities: $e';
      _setState(ProviderState.error);
    }
  }

  // =========================================================
  // CRUD Operations
  // =========================================================

  /// Inserts a new activity into the database and updates local state.
  Future<bool> addActivity(FitnessActivity activity) async {
    try {
      final newId = await _service.addActivity(activity);
      // Add the returned activity (with its new id) to the local list
      final inserted = activity.copyWith(id: newId);
      _activities.insert(0, inserted); // Insert at top (newest first)
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add activity: $e';
      notifyListeners();
      return false;
    }
  }

  /// Updates an existing activity in the database and local state.
  Future<bool> updateActivity(FitnessActivity updated) async {
    try {
      await _service.updateActivity(updated);
      final index = _activities.indexWhere((a) => a.id == updated.id);
      if (index != -1) {
        _activities[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update activity: $e';
      notifyListeners();
      return false;
    }
  }

  /// Deletes an activity by its ID from the database and local state.
  Future<bool> deleteActivity(int id) async {
    try {
      await _service.deleteActivity(id);
      _activities.removeWhere((a) => a.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete activity: $e';
      notifyListeners();
      return false;
    }
  }

  // =========================================================
  // Private Helpers
  // =========================================================

  void _setState(ProviderState newState) {
    _state = newState;
    notifyListeners();
  }
}
