// lib/utils/validators.dart
// Form field validation functions for the Add/Edit Activity screen.

class Validators {
  Validators._(); // Prevent instantiation

  /// Validates the exercise type field.
  static String? validateExerciseType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Exercise type is required';
    }
    if (value.trim().length < 2) {
      return 'Please enter a valid exercise type';
    }
    return null; // Valid
  }

  /// Validates the duration field (must be a positive integer ≤ 1440).
  static String? validateDuration(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Duration is required';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Please enter a valid whole number';
    }
    if (parsed <= 0) {
      return 'Duration must be greater than 0 minutes';
    }
    if (parsed > 1440) {
      return 'Duration cannot exceed 1440 minutes (24 hours)';
    }
    return null; // Valid
  }

  /// Validates the calories field (must be a positive integer ≤ 10000).
  static String? validateCalories(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Calories burned is required';
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Please enter a valid whole number';
    }
    if (parsed <= 0) {
      return 'Calories must be greater than 0';
    }
    if (parsed > 10000) {
      return 'Calories seem too high — please double-check';
    }
    return null; // Valid
  }

  /// Validates that a date has been selected.
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }
    // Reject future dates
    if (value.isAfter(DateTime.now())) {
      return 'Date cannot be in the future';
    }
    // Reject dates more than 2 years ago
    final twoYearsAgo = DateTime.now().subtract(const Duration(days: 730));
    if (value.isBefore(twoYearsAgo)) {
      return 'Date is too far in the past';
    }
    return null; // Valid
  }
}
