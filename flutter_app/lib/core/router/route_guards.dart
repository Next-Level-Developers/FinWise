import 'package:go_router/go_router.dart';

String? authGuard(GoRouterState state, {required bool isAuthenticated}) {
  if (isAuthenticated) {
    return null;
  }
  return '/login';
}
