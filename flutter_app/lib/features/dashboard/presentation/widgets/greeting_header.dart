import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${_getGreeting()}, $userName',
              style: AppTextStyles.headlineLarge,
            ),
            const SizedBox(height: 2),
            Text('Welcome to FinWise', style: AppTextStyles.bodySmall),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                size: AppDimensions.iconM,
                color: AppColors.textPrimary,
              ),
            ),
            Positioned(
              top: 8,
              right: 10,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getGreeting() {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    }
    if (hour < 17) {
      return 'Good afternoon';
    }
    return 'Good evening';
  }
}
