import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/consultant.dart';
import '../providers/expert_connect_provider.dart';

class ExpertConnectScreen extends ConsumerWidget {
  const ExpertConnectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Consultant>> consultants = ref.watch(
      consultantsProvider,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Expert Connect')),
      body: consultants.when(
        data: (List<Consultant> items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No consultants available right now.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final Consultant consultant = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Icon(Icons.person_outline),
                  ),
                  title: Text(consultant.name, style: AppTextStyles.titleLarge),
                  subtitle: Text(
                    consultant.specializationLabel,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: Text(
                    '₹${consultant.sessionFeeInr.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => const Center(
          child: Text(
            'Could not load consultants right now.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
