// lib/screens/activity_list_screen.dart
// Displays all logged activities in a scrollable list.
// Supports delete (with confirmation) and navigates to edit screen.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/fitness_activity.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/empty_state_widget.dart';
import 'add_edit_activity_screen.dart';

class ActivityListScreen extends StatelessWidget {
  const ActivityListScreen({super.key});

  Future<void> _deleteActivity(
    BuildContext context,
    ActivityProvider provider,
    FitnessActivity activity,
  ) async {
    await ConfirmationDialog.show(
      context: context,
      title: AppStrings.deleteTitle,
      message: AppStrings.deleteMessage,
      confirmLabel: AppStrings.deleteConfirm,
      cancelLabel: AppStrings.deleteCancelBtn,
      onConfirm: () async {
        final success = await provider.deleteActivity(activity.id!);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success
                    ? AppStrings.activityDeleted
                    : provider.errorMessage,
              ),
              backgroundColor:
                  success ? AppColors.success : AppColors.error,
            ),
          );
        }
      },
    );
  }

  Future<void> _navigateToEdit(
    BuildContext context,
    FitnessActivity activity,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddEditActivityScreen(existingActivity: activity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<ActivityProvider>(
        builder: (context, provider, _) {
          return CustomScrollView(
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
                        AppStrings.activitiesTitle,
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
                actions: [
                  if (provider.activities.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${provider.activities.length} logged',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // --- Loading State ---
              if (provider.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )

              // --- Empty State ---
              else if (provider.activities.isEmpty)
                SliverFillRemaining(
                  child: EmptyStateWidget(
                    title: AppStrings.noActivities,
                    subtitle: AppStrings.noActivitiesSubtitle,
                    icon: Icons.fitness_center_outlined,
                    buttonLabel: 'Log First Workout',
                    onButtonPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddEditActivityScreen(),
                      ),
                    ),
                  ),
                )

              // --- Activities List ---
              else
                SliverPadding(
                  padding: const EdgeInsets.only(top: 4, bottom: 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final activity = provider.activities[index];
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: ActivityCard(
                            key: ValueKey(activity.id),
                            activity: activity,
                            onEdit: () => _navigateToEdit(context, activity),
                            onDelete: () =>
                                _deleteActivity(context, provider, activity),
                          ),
                        );
                      },
                      childCount: provider.activities.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
