import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Schemes for You')),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0x2260A5FA),
                child: Text('🏛️'),
              ),
              title: Text('PM SVANidhi', style: AppTextStyles.titleLarge),
              subtitle: Text(
                'Working capital support for vendors',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              trailing: Chip(
                label: Text('82% Match'),
                backgroundColor: Color(0x224ADE80),
              ),
            ),
          );
        },
      ),
    );
  }
}
