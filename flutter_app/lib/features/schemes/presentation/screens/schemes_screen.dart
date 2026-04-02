import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/scheme_entity.dart';
import '../providers/schemes_provider.dart';

class SchemesScreen extends ConsumerWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<SchemeEntity>> schemes = ref.watch(schemesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Schemes for You')),
      body: schemes.when(
        data: (List<SchemeEntity> items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No schemes available.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final SchemeEntity scheme = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0x2260A5FA),
                    child: Text(scheme.emoji),
                  ),
                  title: Text(scheme.name, style: AppTextStyles.titleLarge),
                  subtitle: Text(
                    scheme.tagline,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: Chip(
                    label: Text('${scheme.matchScore}% Match'),
                    backgroundColor: const Color(0x224ADE80),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => const Center(
          child: Text(
            'Could not load schemes right now.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
