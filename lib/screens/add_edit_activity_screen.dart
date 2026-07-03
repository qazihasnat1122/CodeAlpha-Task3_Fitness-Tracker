// lib/screens/add_edit_activity_screen.dart
// Dual-purpose screen: Add new activity OR edit existing one.
// Pass [existingActivity] to enter edit mode; omit it for add mode.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/fitness_activity.dart';
import '../providers/activity_provider.dart';
import '../utils/date_utils.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddEditActivityScreen extends StatefulWidget {
  /// If provided, the screen runs in Edit mode; otherwise in Add mode.
  final FitnessActivity? existingActivity;

  const AddEditActivityScreen({super.key, this.existingActivity});

  bool get isEditMode => existingActivity != null;

  @override
  State<AddEditActivityScreen> createState() => _AddEditActivityScreenState();
}

class _AddEditActivityScreenState extends State<AddEditActivityScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // --- Controllers ---
  late final TextEditingController _exerciseTypeController;
  late final TextEditingController _durationController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _dateController;

  // --- State ---
  DateTime? _selectedDate;
  bool _isSaving = false;

  // --- Animation ---
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // Pre-fill values if in edit mode
    final a = widget.existingActivity;
    _exerciseTypeController =
        TextEditingController(text: a?.exerciseType ?? '');
    _durationController =
        TextEditingController(text: a != null ? '${a.duration}' : '');
    _caloriesController =
        TextEditingController(text: a != null ? '${a.calories}' : '');
    _selectedDate = a?.date ?? DateTime.now();
    _dateController = TextEditingController(
      text: FitnessDateUtils.formatDisplayDate(_selectedDate!),
    );

    // Entrance animation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _exerciseTypeController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _dateController.dispose();
    _animController.dispose();
    super.dispose();
  }

  // =========================================================
  // Date Picker
  // =========================================================

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 730)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = FitnessDateUtils.formatDisplayDate(picked);
      });
    }
  }

  // =========================================================
  // Save Handler
  // =========================================================

  Future<void> _save() async {
    // Validate form fields
    if (!_formKey.currentState!.validate()) return;

    // Validate date separately (not in a TextFormField)
    final dateError = Validators.validateDate(_selectedDate);
    if (dateError != null) {
      _showError(dateError);
      return;
    }

    setState(() => _isSaving = true);

    final provider = context.read<ActivityProvider>();
    bool success;

    if (widget.isEditMode) {
      // Update existing
      final updated = widget.existingActivity!.copyWith(
        exerciseType: _exerciseTypeController.text.trim(),
        duration: int.parse(_durationController.text.trim()),
        calories: int.parse(_caloriesController.text.trim()),
        date: _selectedDate!,
      );
      success = await provider.updateActivity(updated);
    } else {
      // Insert new
      final newActivity = FitnessActivity(
        exerciseType: _exerciseTypeController.text.trim(),
        duration: int.parse(_durationController.text.trim()),
        calories: int.parse(_caloriesController.text.trim()),
        date: _selectedDate!,
      );
      success = await provider.addActivity(newActivity);
    }

    setState(() => _isSaving = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditMode
                ? AppStrings.activityUpdated
                : AppStrings.activityAdded,
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } else {
      _showError(provider.errorMessage);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  // =========================================================
  // Build
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          widget.isEditMode
              ? AppStrings.editActivity
              : AppStrings.addActivity,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Close',
        ),
        actions: [
          // Quick-save icon in app bar
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: GestureDetector(
            // Dismiss keyboard on tap outside
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header card
                    _HeaderCard(isEditMode: widget.isEditMode),
                    const SizedBox(height: 24),

                    // --- Exercise Type ---
                    const _FieldLabel(text: 'Exercise Type'),
                    const SizedBox(height: 8),
                    // Dropdown for predefined types + free text option
                    _ExerciseTypeDropdown(
                      controller: _exerciseTypeController,
                    ),
                    const SizedBox(height: 20),

                    // --- Duration ---
                    const _FieldLabel(text: AppStrings.duration),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _durationController,
                      label: AppStrings.duration,
                      hint: AppStrings.hintDuration,
                      prefixIcon: Icons.timer_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: Validators.validateDuration,
                    ),
                    const SizedBox(height: 20),

                    // --- Calories ---
                    const _FieldLabel(text: AppStrings.calories),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _caloriesController,
                      label: AppStrings.calories,
                      hint: AppStrings.hintCalories,
                      prefixIcon: Icons.local_fire_department_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: Validators.validateCalories,
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),

                    // --- Date ---
                    const _FieldLabel(text: AppStrings.date),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _dateController,
                      label: AppStrings.date,
                      prefixIcon: Icons.calendar_today_outlined,
                      readOnly: true,
                      onTap: _pickDate,
                      validator: (_) => Validators.validateDate(_selectedDate),
                    ),
                    const SizedBox(height: 36),

                    // --- Action Buttons ---
                    PrimaryButton(
                      label: AppStrings.saveActivity,
                      icon: widget.isEditMode
                          ? Icons.check_rounded
                          : Icons.add_rounded,
                      onPressed: _isSaving ? null : _save,
                      isLoading: _isSaving,
                    ),
                    const SizedBox(height: 12),
                    SecondaryButton(
                      label: AppStrings.cancel,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// Private Sub-Widgets
// =============================================================

class _HeaderCard extends StatelessWidget {
  final bool isEditMode;

  const _HeaderCard({required this.isEditMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isEditMode ? Icons.edit_rounded : Icons.add_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditMode ? 'Edit Activity' : 'Log New Activity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isEditMode
                    ? 'Update your workout details'
                    : 'Fill in your workout details below',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      ),
    );
  }
}

/// Dropdown + free-text input for exercise type selection.
class _ExerciseTypeDropdown extends StatefulWidget {
  final TextEditingController controller;

  const _ExerciseTypeDropdown({required this.controller});

  @override
  State<_ExerciseTypeDropdown> createState() => _ExerciseTypeDropdownState();
}

class _ExerciseTypeDropdownState extends State<_ExerciseTypeDropdown> {
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    // Check if current value matches a predefined type
    if (AppStrings.exerciseTypes.contains(widget.controller.text)) {
      _selectedType = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedType,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: const Icon(Icons.sports_gymnastics_rounded,
            size: 20, color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelText: AppStrings.exerciseType,
        hintText: AppStrings.hintExerciseType,
        labelStyle: const TextStyle(
            color: AppColors.textSecondary, fontSize: 14),
        hintStyle:
            const TextStyle(color: AppColors.textHint, fontSize: 14),
      ),
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: AppColors.textSecondary),
      items: AppStrings.exerciseTypes
          .map(
            (type) => DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value;
          widget.controller.text = value ?? '';
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return Validators.validateExerciseType(widget.controller.text);
        }
        return null;
      },
    );
  }
}
