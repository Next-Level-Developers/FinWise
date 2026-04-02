import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class ExpertConnectScreen extends StatelessWidget {
  const ExpertConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Expert Connect')),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
            ),
            child: const ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.surfaceElevated,
                child: Icon(Icons.person_outline),
              ),
              title: Text('Aditi Sharma', style: AppTextStyles.titleLarge),
              subtitle: Text(
                'Tax Planning • Retirement',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              trailing: Text(
                '₹499',
                style: TextStyle(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
