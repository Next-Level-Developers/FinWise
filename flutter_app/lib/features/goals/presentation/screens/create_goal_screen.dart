import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goals_provider.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  final TextEditingController _targetDateController = TextEditingController();
  final TextEditingController _monthlyContributionController =
      TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _categoryController.dispose();
    _titleController.dispose();
    _targetAmountController.dispose();
    _targetDateController.dispose();
    _monthlyContributionController.dispose();
    super.dispose();
  }

  Future<void> _saveGoal() async {
    final String title = _titleController.text.trim();
    final String categoryInput = _categoryController.text.trim();
    final double? targetAmount = double.tryParse(
      _targetAmountController.text.trim(),
    );
    final double? monthlyContribution = double.tryParse(
      _monthlyContributionController.text.trim(),
    );
    final DateTime? targetDate = _parseDate(_targetDateController.text.trim());

    if (title.isEmpty || targetAmount == null || targetAmount <= 0) {
      _showMessage('Enter a valid goal title and target amount.');
      return;
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(createGoalProvider)
          .call(
            GoalEntity(
              title: title,
              target: targetAmount,
              emoji: _categoryEmoji(categoryInput),
              category: _normalizeCategory(categoryInput),
              targetDate: targetDate,
              monthlyContribution: monthlyContribution,
              progressPercent: 0,
              currentAmount: 0,
              status: 'active',
              priority: 'medium',
              milestones: const <GoalMilestone>[
                GoalMilestone(percent: 25),
                GoalMilestone(percent: 50),
                GoalMilestone(percent: 75),
                GoalMilestone(percent: 100),
              ],
            ),
          );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (error) {
      _showMessage('Could not save goal right now.');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  DateTime? _parseDate(String input) {
    if (input.isEmpty) {
      return null;
    }
    try {
      return DateFormat('MMM yyyy').parseStrict(input);
    } catch (_) {
      try {
        return DateFormat('MMMM yyyy').parseStrict(input);
      } catch (_) {
        return null;
      }
    }
  }

  String _normalizeCategory(String input) {
    final String normalized = input.trim().toLowerCase();
    if (normalized.isEmpty) {
      return 'custom';
    }
    if (normalized.contains('home')) return 'house';
    if (normalized.contains('emergency')) return 'emergency_fund';
    if (normalized.contains('vacation')) return 'vacation';
    if (normalized.contains('invest')) return 'custom';
    if (normalized.contains('wedding')) return 'wedding';
    return normalized.replaceAll(' ', '_');
  }

  String _categoryEmoji(String input) {
    final String normalized = input.toLowerCase();
    if (normalized.contains('home')) return '🏠';
    if (normalized.contains('emergency')) return '🚨';
    if (normalized.contains('vacation')) return '✈️';
    if (normalized.contains('invest')) return '📈';
    if (normalized.contains('wedding')) return '💍';
    return '🎯';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('New Goal')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: <Widget>[
          _GoalField(
            label: 'Goal Category',
            controller: _categoryController,
            hint: 'Home',
          ),
          const SizedBox(height: 12),
          _GoalField(
            label: 'Goal Title',
            controller: _titleController,
            hint: 'Home Down Payment',
          ),
          const SizedBox(height: 12),
          _GoalField(
            label: 'Target Amount',
            controller: _targetAmountController,
            hint: '1000000',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _GoalField(
            label: 'Target Date',
            controller: _targetDateController,
            hint: 'Dec 2028',
          ),
          const SizedBox(height: 12),
          _GoalField(
            label: 'Monthly Contribution',
            controller: _monthlyContributionController,
            hint: '20000',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 18),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: ElevatedButton(
          onPressed: _saving ? null : _saveGoal,
          child: Text(_saving ? 'Saving...' : 'Save Goal'),
        ),
      ),
    );
  }
}

class _GoalField extends StatelessWidget {
  const _GoalField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: AppTextStyles.titleLarge),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
            style: AppTextStyles.bodyLarge,
          ),
        ),
      ],
    );
  }
}
