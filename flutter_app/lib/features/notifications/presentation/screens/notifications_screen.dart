import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/app_notification.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<AppNotification>> notifications = ref.watch(
      notificationsProvider,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await ref.watch(notificationsRepositoryProvider).markAllAsRead();
              ref.invalidate(notificationsProvider);
            },
            child: const Text(
              'Mark All Read',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: notifications.when(
        data: (List<AppNotification> items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No notifications available.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            children: items.map((AppNotification item) {
              return _NotificationTile(
                icon: _iconForType(item.type),
                title: item.title,
                body: item.body,
                color: _colorForType(item.type),
                showUnreadDot: !item.isRead,
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Text('Could not load notifications right now.'),
          ),
        ),
      ),
    );
  }

  static IconData _iconForType(String type) {
    switch (type) {
      case 'overspend_warning':
      case 'budget_alert':
        return Icons.warning_amber_rounded;
      case 'goal_milestone':
        return Icons.emoji_events_outlined;
      case 'badge_earned':
      case 'streak_reminder':
      case 'daily_tip':
        return Icons.auto_awesome;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  static Color _colorForType(String type) {
    switch (type) {
      case 'overspend_warning':
      case 'budget_alert':
        return AppColors.debit;
      case 'goal_milestone':
        return AppColors.accentGold;
      case 'badge_earned':
      case 'streak_reminder':
      case 'daily_tip':
        return AppColors.accentPurple;
      default:
        return AppColors.primary;
    }
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.showUnreadDot,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final bool showUnreadDot;

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
          if (showUnreadDot)
            const CircleAvatar(radius: 4, backgroundColor: AppColors.primary),
        ],
      ),
    );
  }
}
