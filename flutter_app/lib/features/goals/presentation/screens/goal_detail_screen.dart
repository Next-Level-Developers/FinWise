import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/finwise_advanced_widgets.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goals_provider.dart';

class GoalDetailScreen extends ConsumerWidget {
  const GoalDetailScreen({super.key, this.goalId = ''});

  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GoalEntity?> goal = ref.watch(goalByIdProvider(goalId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(goal.valueOrNull?.title ?? 'Goal Details'),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: Text(
              goal.valueOrNull?.status.toUpperCase() ?? 'ACTIVE',
              style: const TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: goal.when(
        data: (GoalEntity? goalData) {
          if (goalData == null) {
            return const Center(
              child: Text(
                'Goal not found.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            children: <Widget>[
              Center(
                child: GoalProgressArc(
                  progress: goalData.progressRatio,
                  emoji: goalData.emoji,
                  label: goalData.title,
                ),
              ),
              const SizedBox(height: 16),
              MilestoneTimeline(progress: goalData.progressRatio),
              const SizedBox(height: 16),
              AiGoalAdviceCard(
                advice:
                    goalData.aiSuggestion ??
                    'This goal is progressing steadily. Keeping monthly contributions consistent will help you hit the target on time.',
                onRefresh: () {},
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: AppColors.surface,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (BuildContext bottomSheetContext) {
                      return _ContributionSheet(
                        goal: goalData,
                        onConfirm: (double amount) async {
                          try {
                            await ref
                                .read(addGoalContributionProvider)
                                .call(goalId: goalData.id, amount: amount);
                            if (bottomSheetContext.mounted) {
                              bottomSheetContext.pop();
                            }
                          } catch (error) {
                            if (bottomSheetContext.mounted) {
                              ScaffoldMessenger.of(bottomSheetContext)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(_friendlyError(error)),
                                  ),
                                );
                            }
                          }
                        },
                      );
                    },
                  );
                },
                child: const Text('Add Contribution'),
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
        message.contains('Setting up goals data')) {
      return 'Setting up goals data... please wait';
    }
    return 'Could not load goal details right now.';
  }
}

class _ContributionSheet extends StatefulWidget {
  const _ContributionSheet({required this.goal, required this.onConfirm});

  final GoalEntity goal;
  final Future<void> Function(double amount) onConfirm;

  @override
  State<_ContributionSheet> createState() => _ContributionSheetState();
}

class _ContributionSheetState extends State<_ContributionSheet> {
  final TextEditingController _amountController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final double? amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onConfirm(amount);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingL,
        right: AppDimensions.paddingL,
        top: AppDimensions.paddingL,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Center(
            child: SizedBox(
              width: 44,
              height: 4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.textTertiary,
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Add Contribution',
            style: AppTextStyles.titleLarge.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Text(widget.goal.title, style: AppTextStyles.bodyLarge),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(hintText: 'Contribution amount'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              minimumSize: const Size.fromHeight(50),
            ),
            child: Text(_saving ? 'Saving...' : 'Confirm Contribution'),
          ),
        ],
      ),
    );
  }
}
