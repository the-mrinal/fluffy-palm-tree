import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paper_bulls/utils/constants.dart';

// Import all pages (will be created later)
import 'package:paper_bulls/pages/dashboard_page.dart';
import 'package:paper_bulls/pages/login_page.dart';
import 'package:paper_bulls/pages/get_started_page.dart';
import 'package:paper_bulls/pages/mock_trading_onboarding_page.dart';
import 'package:paper_bulls/pages/trading_options_selection_page.dart';
import 'package:paper_bulls/pages/mock_trading_dashboard_page.dart';
import 'package:paper_bulls/pages/pnl_overview_page.dart';
import 'package:paper_bulls/pages/api_test_page.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  static final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppConstants.dashboardRoute,
    debugLogDiagnostics: true,
    routes: [
      // Dashboard route
      GoRoute(
        path: AppConstants.dashboardRoute,
        name: 'dashboard',
        builder: (context, state) => const DashboardPage(),
      ),

      // Login route
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Get Started route
      GoRoute(
        path: AppConstants.getStartedRoute,
        name: 'getStarted',
        builder: (context, state) => const GetStartedPage(),
      ),

      // Mock Trading Onboarding route
      GoRoute(
        path: AppConstants.mockTradingOnboardingRoute,
        name: 'mockTradingOnboarding',
        builder: (context, state) => const MockTradingOnboardingPage(),
      ),

      // Trading Options Selection route
      GoRoute(
        path: AppConstants.tradingOptionsSelectionRoute,
        name: 'tradingOptionsSelection',
        builder: (context, state) => const TradingOptionsSelectionPage(),
      ),

      // Mock Trading Dashboard route
      GoRoute(
        path: AppConstants.mockTradingDashboardRoute,
        name: 'mockTradingDashboard',
        builder: (context, state) => const MockTradingDashboardPage(),
      ),

      // PnL Overview route
      GoRoute(
        path: AppConstants.pnlOverviewRoute,
        name: 'pnlOverview',
        builder: (context, state) => const PnLOverviewPage(),
      ),

      // API Test route
      GoRoute(
        path: AppConstants.apiTestRoute,
        name: 'apiTest',
        builder: (context, state) => const ApiTestPage(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Page not found',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.dashboardRoute),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );

  // Navigation methods
  static void navigateTo(BuildContext context, String route) {
    context.go(route);
  }

  static void navigateToNamed(BuildContext context, String name) {
    context.goNamed(name);
  }

  static void navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppConstants.dashboardRoute);
    }
  }

  /// Navigates to the dashboard and removes all previous routes
  /// Use this after completing the login flow or trading options selection
  static void navigateAndRemoveUntil(BuildContext context, String route) {
    // GoRouter doesn't have a direct equivalent to Navigator.pushAndRemoveUntil
    // So we use go() which replaces the current location
    context.go(route);
  }

  /// Navigates to the Mock Trading Dashboard after completing setup
  /// This prevents returning to the setup screens
  static void navigateToMockTradingDashboard(BuildContext context) {
    navigateAndRemoveUntil(context, AppConstants.mockTradingDashboardRoute);
  }

  /// Navigates to the Get Started page after successful login
  /// This prevents returning to the login screen
  static void navigateAfterLogin(BuildContext context) {
    navigateAndRemoveUntil(context, AppConstants.getStartedRoute);
  }
}
