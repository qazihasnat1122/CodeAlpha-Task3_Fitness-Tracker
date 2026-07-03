// lib/models/fitness_activity.dart
// Core data model representing a single fitness activity entry.
// Includes serialization helpers for SQLite persistence.

class FitnessActivity {
  final int? id;              // Auto-incremented SQLite primary key (null before insert)
  final String exerciseType;  // e.g. "Running", "Cycling"
  final int duration;         // Duration in minutes
  final int calories;         // Calories burned
  final DateTime date;        // Date of the activity

  const FitnessActivity({
    this.id,
    required this.exerciseType,
    required this.duration,
    required this.calories,
    required this.date,
  });

  // --- Serialization ---

  /// Converts the model to a Map for SQLite insertion/update.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseType': exerciseType,
      'duration': duration,
      'calories': calories,
      // Store date as ISO 8601 string for reliable parsing
      'date': date.toIso8601String(),
    };
  }

  /// Creates a FitnessActivity from a SQLite result row.
  factory FitnessActivity.fromMap(Map<String, dynamic> map) {
    return FitnessActivity(
      id: map['id'] as int?,
      exerciseType: map['exerciseType'] as String,
      duration: map['duration'] as int,
      calories: map['calories'] as int,
      date: DateTime.parse(map['date'] as String),
    );
  }

  // --- Utility ---

  /// Creates a copy of the model with optionally overridden fields.
  /// Useful for edit operations without mutating the original.
  FitnessActivity copyWith({
    int? id,
    String? exerciseType,
    int? duration,
    int? calories,
    DateTime? date,
  }) {
    return FitnessActivity(
      id: id ?? this.id,
      exerciseType: exerciseType ?? this.exerciseType,
      duration: duration ?? this.duration,
      calories: calories ?? this.calories,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'FitnessActivity(id: $id, exerciseType: $exerciseType, '
        'duration: $duration, calories: $calories, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FitnessActivity &&
        other.id == id &&
        other.exerciseType == exerciseType &&
        other.duration == duration &&
        other.calories == calories &&
        other.date == date;
  }

  @override
  int get hashCode =>
      Object.hash(id, exerciseType, duration, calories, date);
}
