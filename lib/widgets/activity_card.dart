// lib/widgets/activity_card.dart
// Card widget for displaying a single FitnessActivity in the activity list.
// Includes color-coded exercise type chip, stats, and edit/delete actions.

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/fitness_activity.dart';
import '../utils/date_utils.dart';

class ActivityCard extends StatelessWidget {
  final FitnessActivity activity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onEdit,
    required this.onDelete,
  });

  /// Returns a color associated with the given exercise type.
  Color _getExerciseColor(String type) {
    switch (type.toLowerCase()) {
      case 'running':
        return AppColors.colorRunning;
      case 'cycling':
        return AppColors.colorCycling;
      case 'swimming':
        return AppColors.colorSwimming;
      case 'yoga':
        return AppColors.colorYoga;
      case 'weight training':
        return AppColors.colorWeightlifting;
      case 'walking':
        return AppColors.colorWalking;
      default:
        return AppColors.colorDefault;
    }
  }

  /// Returns an icon for the exercise type.
  IconData _getExerciseIcon(String type) {
    switch (type.toLowerCase()) {
      case 'running':
        return Icons.directions_run_rounded;
      case 'walking':
        return Icons.directions_walk_rounded;
      case 'cycling':
        return Icons.directions_bike_rounded;
      case 'swimming':
        return Icons.pool_rounded;
      case 'yoga':
        return Icons.self_improvement_rounded;
      case 'weight training':
        return Icons.fitness_center_rounded;
      case 'hiit':
        return Icons.flash_on_rounded;
      case 'pilates':
        return Icons.accessibility_new_rounded;
      case 'rowing':
        return Icons.rowing_rounded;
      case 'dancing':
        return Icons.music_note_rounded;
      default:
        return Icons.sports_gymnastics_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseColor = _getExerciseColor(activity.exerciseType);
    final exerciseIcon = _getExerciseIcon(activity.exerciseType);
    final isToday = FitnessDateUtils.isToday(activity.date);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Exercise icon badge
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: exerciseColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(exerciseIcon, color: exerciseColor, size: 26),
                ),
                const SizedBox(width: 14),

                // Main content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exercise type + "Today" chip
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              activity.exerciseType,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isToday) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Today',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Stats row: duration | calories
                      Row(
                        children: [
                          _StatChip(
                            icon: Icons.timer_outlined,
                            label: '${activity.duration} min',
                          ),
                          const SizedBox(width: 12),
                          _StatChip(
                            icon: Icons.local_fire_department_outlined,
                            label: '${activity.calories} kcal',
                            color: AppColors.colorRunning,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Date
                      Text(
                        FitnessDateUtils.formatDisplayDate(activity.date),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Column(
                  children: [
                    _ActionButton(
                      icon: Icons.edit_outlined,
                      color: AppColors.primary,
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    const SizedBox(height: 4),
                    _ActionButton(
                      icon: Icons.delete_outline_rounded,
                      color: AppColors.error,
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Private Sub-Widgets ---

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    this.color = AppColors.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}
