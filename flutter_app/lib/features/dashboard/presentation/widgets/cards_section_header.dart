import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class CardsSectionHeader extends StatelessWidget {
  const CardsSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Your cards', style: AppTextStyles.titleLarge),
          GestureDetector(
            onTap: () => context.push('/app/transactions/add'),
            child: Row(
              children: <Widget>[
                const Icon(Icons.add, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 2),
                Text('New card', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
