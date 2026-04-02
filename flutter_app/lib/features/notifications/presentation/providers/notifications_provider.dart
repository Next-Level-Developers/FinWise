import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<int> unreadNotificationsProvider = StateProvider<int>((Ref ref) => 0);
