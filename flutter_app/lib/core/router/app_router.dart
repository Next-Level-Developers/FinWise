import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai_chat/presentation/screens/ai_chat_list_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/budget/presentation/screens/budget_screen.dart';
import '../../features/budget/presentation/screens/budget_detail_screen.dart';
import '../../features/budget/presentation/screens/budget_setup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/expert_connect/presentation/screens/expert_connect_screen.dart';
import '../../features/goals/presentation/screens/create_goal_screen.dart';
import '../../features/goals/presentation/screens/goal_detail_screen.dart';
import '../../features/goals/presentation/screens/goals_screen.dart';
import '../../features/learn/presentation/screens/learn_hub_screen.dart';
import '../../features/learn/presentation/screens/lesson_reader_screen.dart';
import '../../features/learn/presentation/screens/module_detail_screen.dart';
import '../../features/learn/presentation/screens/quiz_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_shell_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/schemes/presentation/screens/schemes_screen.dart';
import '../../features/transactions/presentation/screens/add_transaction_screen.dart';
import '../../features/transactions/presentation/screens/ocr_scan_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import '../../features/ai_chat/presentation/screens/ai_chat_screen.dart';
import '../../features/video_insights/presentation/screens/video_insights_screen.dart';
import '../../shared/widgets/finwise_bottom_nav.dart';
import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (BuildContext context, GoRouterState state) {
    // Skip redirect on splash to avoid loop
    if (state.uri.path == AppRoutes.splash) {
      return null;
    }
    // Default: navigate to dashboard (authenticated state)
    // In production, check actual auth state here
    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (BuildContext context, GoRouterState state) =>
          const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (BuildContext context, GoRouterState state) =>
          const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (BuildContext context, GoRouterState state) =>
          const OnboardingShellScreen(),
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return _AppShell(state: state, child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.dashboard,
          builder: (BuildContext context, GoRouterState state) =>
              const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.transactions,
          builder: (BuildContext context, GoRouterState state) =>
              const TransactionsScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: 'add',
              builder: (BuildContext context, GoRouterState state) =>
                  const AddTransactionScreen(),
            ),
            GoRoute(
              path: 'scan',
              builder: (BuildContext context, GoRouterState state) =>
                  const OcrScanScreen(),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.budget,
          builder: (BuildContext context, GoRouterState state) =>
              const BudgetScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: 'setup',
              builder: (BuildContext context, GoRouterState state) =>
                  const BudgetSetupScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (BuildContext context, GoRouterState state) =>
                  BudgetDetailScreen(
                    category: state.pathParameters['id'] ?? 'food',
                  ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.goals,
          builder: (BuildContext context, GoRouterState state) =>
              const GoalsScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: 'create',
              builder: (BuildContext context, GoRouterState state) =>
                  const CreateGoalScreen(),
            ),
            GoRoute(
              path: ':id',
              builder: (BuildContext context, GoRouterState state) =>
                  GoalDetailScreen(goalId: state.pathParameters['id'] ?? ''),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.learn,
          builder: (BuildContext context, GoRouterState state) =>
              const LearnHubScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: ':moduleId',
              builder: (BuildContext context, GoRouterState state) =>
                  ModuleDetailScreen(
                    moduleId: state.pathParameters['moduleId'] ?? '',
                  ),
              routes: <RouteBase>[
                GoRoute(
                  path: 'lesson/:lessonId',
                  builder: (BuildContext context, GoRouterState state) =>
                      LessonReaderScreen(
                        moduleId: state.pathParameters['moduleId'] ?? '',
                        lessonId: state.pathParameters['lessonId'] ?? '',
                      ),
                ),
                GoRoute(
                  path: 'quiz',
                  builder: (BuildContext context, GoRouterState state) =>
                      QuizScreen(
                        moduleId: state.pathParameters['moduleId'] ?? '',
                      ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.aiChat,
          builder: (BuildContext context, GoRouterState state) =>
              const AiChatListScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: ':sessionId',
              builder: (BuildContext context, GoRouterState state) =>
                  const AiChatScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.videoInsights,
      builder: (BuildContext context, GoRouterState state) =>
          const VideoInsightsScreen(),
    ),
    GoRoute(
      path: AppRoutes.schemes,
      builder: (BuildContext context, GoRouterState state) =>
          const SchemesScreen(),
    ),
    GoRoute(
      path: AppRoutes.expertConnect,
      builder: (BuildContext context, GoRouterState state) =>
          const ExpertConnectScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (BuildContext context, GoRouterState state) =>
          const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (BuildContext context, GoRouterState state) =>
          const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsScreen(),
    ),
  ],
);

class _AppShell extends StatelessWidget {
  const _AppShell({required this.state, required this.child});

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final String location = state.uri.path;
    final List<String> routes = <String>[
      AppRoutes.dashboard,
      AppRoutes.transactions,
      AppRoutes.budget,
      AppRoutes.goals,
      AppRoutes.learn,
    ];

    final int index = routes.indexWhere((String route) {
      return location == route || location.startsWith('$route/');
    });

    return Scaffold(
      body: child,
      bottomNavigationBar: FinWiseBottomNav(
        currentIndex: index < 0 ? 0 : index,
      ),
    );
  }
}
