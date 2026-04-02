import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text(
              'Mark All Read',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        children: const <Widget>[
          _NotificationTile(
            icon: Icons.warning_amber_rounded,
            title: 'Overspend Warning',
            body: 'Food spending is above target by 16%',
            color: AppColors.debit,
          ),
          _NotificationTile(
            icon: Icons.emoji_events_outlined,
            title: 'Goal Milestone',
            body: 'Emergency fund reached 50%',
            color: AppColors.accentGold,
          ),
          _NotificationTile(
            icon: Icons.auto_awesome,
            title: 'Badge Earned',
            body: 'You completed a 7-day learning streak',
            color: AppColors.accentPurple,
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: AppTextStyles.titleLarge),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const CircleAvatar(radius: 4, backgroundColor: AppColors.primary),
        ],
      ),
    );
  }
}
