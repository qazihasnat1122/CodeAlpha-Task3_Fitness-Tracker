// lib/utils/date_utils.dart
// Date formatting and helper utilities for the Fitness Tracker App.

import 'package:intl/intl.dart';

class FitnessDateUtils {
  FitnessDateUtils._(); // Prevent instantiation

  // --- Formatters ---

  /// Formats a date as "Mon, 29 Jun 2026"
  static String formatDisplayDate(DateTime date) {
    return DateFormat('EEE, d MMM yyyy').format(date);
  }

  /// Formats a date as "29 Jun" (short form for charts)
  static String formatShortDate(DateTime date) {
    return DateFormat('d MMM').format(date);
  }

  /// Formats a date as "Monday" (full weekday)
  static String formatWeekday(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Formats a date as "Mon" (short weekday for axis labels)
  static String formatShortWeekday(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  /// Formats a DateTime to ISO 8601 date-only string "yyyy-MM-dd"
  static String toIsoDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // --- Week Boundaries ---

  /// Returns the Monday (start) of the week containing [date].
  static DateTime startOfWeek(DateTime date) {
    // weekday: 1=Monday, 7=Sunday
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }

  /// Returns the Sunday (end) of the week containing [date].
  static DateTime endOfWeek(DateTime date) {
    final start = startOfWeek(date);
    return start.add(const Duration(days: 6));
  }

  /// Returns a list of 7 DateTime objects for the current week (Mon–Sun).
  static List<DateTime> currentWeekDays() {
    final start = startOfWeek(DateTime.now());
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  // --- Comparison Helpers ---

  /// Returns true if [date] is today (ignores time component).
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Returns true if [date] falls within the current calendar week.
  static bool isThisWeek(DateTime date) {
    final start = startOfWeek(DateTime.now());
    final end = endOfWeek(DateTime.now());
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  /// Strips the time component from a DateTime.
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
