import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../providers/onboarding_provider.dart';

class OnboardingShellScreen extends ConsumerWidget {
  const OnboardingShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int step = ref.watch(onboardingStepProvider);
    final List<String> titles = <String>[
      'Occupation',
      'Income',
      'Goals',
      'Language',
      'Complete',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: List<Widget>.generate(5, (int index) {
                  final bool active = index <= step;
                  return Expanded(
                    child: Container(
                      height: 8,
                      margin: EdgeInsets.only(right: index == 4 ? 0 : 8),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 22),
              const Text(
                'Tell us about you',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                titles[step],
                style: const TextStyle(
                  color: AppColors.accentGold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'We personalize budgets, goals, and learning using this profile.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Step ${1 + step} of 5',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Occupation, income, goals and language selectors are placed here.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List<Widget>.generate(3, (int index) {
                          return Chip(
                            label: Text('${titles[step]} option ${index + 1}'),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: step == 0
                    ? null
                    : () {
                        ref.read(onboardingStepProvider.notifier).state =
                            step - 1;
                      },
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (step < 4) {
                    ref.read(onboardingStepProvider.notifier).state = step + 1;
                    return;
                  }
                  context.go(AppRoutes.dashboard);
                },
                child: Text(step < 4 ? 'Next' : 'Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
