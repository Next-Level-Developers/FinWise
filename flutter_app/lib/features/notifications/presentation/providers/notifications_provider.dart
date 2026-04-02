import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/notifications_repository_impl.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

final Provider<NotificationsRepository> notificationsRepositoryProvider =
    Provider<NotificationsRepository>((Ref ref) {
      return NotificationsRepositoryImpl();
    });

final FutureProvider<List<AppNotification>> notificationsProvider =
    FutureProvider<List<AppNotification>>((Ref ref) {
      return ref.watch(notificationsRepositoryProvider).getNotifications();
    });

final FutureProvider<int> unreadNotificationsProvider = FutureProvider<int>((
  Ref ref,
) async {
  final List<AppNotification> notifications = await ref.watch(
    notificationsProvider.future,
  );
  return notifications.where((AppNotification item) => !item.isRead).length;
});
