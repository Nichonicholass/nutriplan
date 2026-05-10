import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/meal_plan/presentation/pages/generate_plan_screen.dart';
import '../../features/meal_plan/presentation/pages/meal_plan_result_screen.dart';
import '../../features/grocery/presentation/pages/grocery_list_screen.dart';
import '../../features/saved_plans/presentation/pages/saved_plans_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../providers/app_providers.dart';
import 'scaffold_with_nav.dart';

final routerProvider = Provider<GoRouter>((ref) {
  ref.watch(onboardingProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNav(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/generate',
                name: 'generate',
                builder: (context, state) => const GeneratePlanScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/saved',
                name: 'saved',
                builder: (context, state) => const SavedPlansScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/result',
        name: 'result',
        builder: (context, state) => const MealPlanResultScreen(),
      ),
      GoRoute(
        path: '/grocery',
        name: 'grocery',
        builder: (context, state) {
          final planId = state.extra as String?;
          return GroceryListScreen(planId: planId);
        },
      ),
    ],
  );
});
