import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/finwise_advanced_widgets.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goals_provider.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<GoalEntity>> goals = ref.watch(goalsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Goals'),
        actions: <Widget>[
          IconButton(
            onPressed: () => context.push('${AppRoutes.goals}/create'),
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ],
      ),
      body: goals.when(
        data: (List<GoalEntity> items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No goals available.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              final GoalEntity goal = items[index];
              final String amountLabel =
                  '₹${goal.currentAmount.toStringAsFixed(0)} of ₹${goal.target.toStringAsFixed(0)}';
              final String daysLeft = goal.targetDate == null
                  ? 'No target date'
                  : '${goal.targetDate!.difference(DateTime.now()).inDays.clamp(0, 999)} days left';

              return InkWell(
                onTap: () => context.push('${AppRoutes.goals}/${goal.id}'),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          GoalProgressArc(
                            progress: goal.progressRatio,
                            emoji: goal.emoji,
                            label: '',
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  goal.title,
                                  style: AppTextStyles.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  amountLabel,
                                  style: AppTextStyles.bodySmall,
                                ),
                                const SizedBox(height: 10),
                                _GoalDaysChip(label: daysLeft),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: goal.progressRatio,
                          minHeight: 8,
                          color: AppColors.primary,
                          backgroundColor: AppColors.surfaceElevated,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
        message.contains('Setting up goals data')) {
      return 'Setting up goals data... please wait';
    }
    return 'Could not load goals right now.';
  }
}

class _GoalDaysChip extends StatelessWidget {
  const _GoalDaysChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x22F4C96B),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accentGold,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
