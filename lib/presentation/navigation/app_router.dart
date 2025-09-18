import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/home_screen.dart';
import '../screens/placement_test_screen.dart';
import '../screens/daily_tasks_screen.dart';
import '../screens/learn_mode_screen.dart';
import '../screens/practice_mode_screen.dart';
import '../screens/arcade_mode_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/badges_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
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
      GoRoute(
        path: '/placement-test',
        name: 'placement-test',
        builder: (context, state) => const PlacementTestScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: '/daily-tasks',
            name: 'daily-tasks',
            builder: (context, state) => const DailyTasksScreen(),
          ),
          GoRoute(
            path: '/learn',
            name: 'learn',
            builder: (context, state) => const LearnModeScreen(),
          ),
          GoRoute(
            path: '/practice',
            name: 'practice',
            builder: (context, state) => const PracticeModeScreen(),
          ),
          GoRoute(
            path: '/arcade',
            name: 'arcade',
            builder: (context, state) => const ArcadeModeScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/badges',
            name: 'badges',
            builder: (context, state) => const BadgesScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

class AppRouter {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String placementTest = '/placement-test';
  static const String home = '/home';
  static const String dailyTasks = '/home/daily-tasks';
  static const String learn = '/home/learn';
  static const String practice = '/home/practice';
  static const String arcade = '/home/arcade';
  static const String profile = '/home/profile';
  static const String dashboard = '/home/dashboard';
  static const String settings = '/home/settings';
  static const String badges = '/home/badges';
}