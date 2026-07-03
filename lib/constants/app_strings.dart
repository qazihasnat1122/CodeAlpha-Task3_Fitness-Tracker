// lib/constants/app_strings.dart
// All string constants used across the application.
// Centralizing strings makes localization easier in the future.

class AppStrings {
  AppStrings._(); // Prevent instantiation

  // --- App Meta ---
  static const String appName = 'Fitness Tracker';
  static const String appTagline = 'Track your journey to a healthier you';

  // --- Navigation ---
  static const String navDashboard = 'Dashboard';
  static const String navActivities = 'Activities';

  // --- Dashboard Screen ---
  static const String dashboardTitle = 'Dashboard';
  static const String todaySummary = "Today's Summary";
  static const String weeklyProgress = 'Weekly Progress';
  static const String totalWorkouts = 'Workouts';
  static const String totalDuration = 'Duration';
  static const String totalCalories = 'Calories';
  static const String minutes = 'min';
  static const String kcal = 'kcal';
  static const String weeklyCaloriesChart = 'Calories This Week';
  static const String goalReached = 'Goal Reached!';
  static const String weeklyGoal = 'Weekly Goal';
  static const String workoutsThisWeek = 'Workouts this week';
  static const String minutesThisWeek = 'Minutes this week';
  static const String caloriesThisWeek = 'Calories this week';

  // --- Activity List Screen ---
  static const String activitiesTitle = 'All Activities';
  static const String noActivities = 'No activities yet';
  static const String noActivitiesSubtitle =
      'Tap the + button to log your first workout';
  static const String activityDeleted = 'Activity deleted successfully';
  static const String activityAdded = 'Activity added successfully';
  static const String activityUpdated = 'Activity updated successfully';

  // --- Add / Edit Activity Screen ---
  static const String addActivity = 'Log Activity';
  static const String editActivity = 'Edit Activity';
  static const String exerciseType = 'Exercise Type';
  static const String duration = 'Duration (minutes)';
  static const String calories = 'Calories Burned';
  static const String date = 'Date';
  static const String saveActivity = 'Save Activity';
  static const String cancel = 'Cancel';
  static const String selectDate = 'Select Date';
  static const String hintExerciseType = 'e.g. Running, Cycling, Yoga...';
  static const String hintDuration = 'e.g. 30';
  static const String hintCalories = 'e.g. 250';

  // --- Validation Messages ---
  static const String fieldRequired = 'This field is required';
  static const String invalidNumber = 'Please enter a valid number';
  static const String mustBePositive = 'Value must be greater than 0';
  static const String durationTooLong =
      'Duration cannot exceed 1440 minutes (24h)';
  static const String caloriesTooHigh =
      'Calories seem too high. Please check your entry';

  // --- Confirmation Dialog ---
  static const String deleteTitle = 'Delete Activity?';
  static const String deleteMessage =
      'This action cannot be undone. The activity will be permanently removed.';
  static const String deleteConfirm = 'Delete';
  static const String deleteCancelBtn = 'Cancel';

  // --- Exercise Types List ---
  static const List<String> exerciseTypes = [
    'Running',
    'Walking',
    'Cycling',
    'Swimming',
    'Yoga',
    'Weight Training',
    'HIIT',
    'Pilates',
    'Rowing',
    'Jump Rope',
    'Dancing',
    'Rock Climbing',
    'Boxing',
    'CrossFit',
    'Other',
  ];

  // --- Days of Week ---
  static const List<String> daysShort = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];
}
