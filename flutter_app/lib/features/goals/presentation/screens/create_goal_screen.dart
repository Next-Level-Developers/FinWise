import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class CreateGoalScreen extends StatelessWidget {
  const CreateGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('New Goal')),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: const <Widget>[
          _GoalField(label: 'Goal Category', value: '🏠 Home'),
          SizedBox(height: 12),
          _GoalField(label: 'Goal Title', value: 'Home Down Payment'),
          SizedBox(height: 12),
          _GoalField(label: 'Target Amount', value: '₹10,00,000'),
          SizedBox(height: 12),
          _GoalField(label: 'Target Date', value: 'Dec 2028'),
          SizedBox(height: 12),
          _GoalField(label: 'Monthly Contribution', value: '₹20,000'),
          SizedBox(height: 18),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: ElevatedButton(onPressed: () {}, child: const Text('Save Goal')),
      ),
    );
  }
}

class _GoalField extends StatelessWidget {
  const _GoalField({required this.label, required this.value});

  final String label;
  final String value;

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
          child: Text(value, style: AppTextStyles.bodyLarge),
        ),
      ],
    );
  }
}
