import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/budget_entity.dart';
import '../providers/budget_provider.dart';

class BudgetSetupScreen extends ConsumerWidget {
  const BudgetSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime now = DateTime.now();
    final String monthKey = DateFormat('yyyy-MM').format(now);
    final AsyncValue<BudgetEntity?> budget = ref.watch(
      currentBudgetProvider(monthKey),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Set Up Budget — ${DateFormat('MMMM yyyy').format(now)}'),
      ),
      body: budget.when(
        data: (BudgetEntity? data) {
          final Map<String, double> limits =
              data?.categoryLimits ?? <String, double>{};

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: BoxDecoration(
                  color: const Color(0x261A1433),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.auto_awesome, color: AppColors.accentPurple),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Generate with AI',
                        style: AppTextStyles.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                ),
                child: const Text(
                  'Set Manually',
                  style: AppTextStyles.titleLarge,
                ),
              ),
              const SizedBox(height: 12),
              if (limits.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'No budget categories found.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              else
                ...limits.entries.toList().asMap().entries.map((entry) {
                  final int index = entry.key;
                  final String category = entry.value.key;
                  final double value = entry.value.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.surfaceElevated,
                          child: Text('${index + 1}'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(category, style: AppTextStyles.bodyLarge),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 96,
                          child: TextField(
                            readOnly: true,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              prefixText: '₹ ',
                              hintText: value.toStringAsFixed(0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save Budget'),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Text(_friendlyError(error)),
          ),
        ),
      ),
    );
  }

  String _friendlyError(Object error) {
    final String message = error.toString();
    if (message.contains('failed-precondition') ||
        message.contains('Setting up budget data')) {
      return 'Setting up budget data... please wait';
    }
    return 'Could not load budget setup right now.';
  }
}
