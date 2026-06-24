import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/signup_page.dart';
import '../../features/authentication/presentation/pages/forgot_password_page.dart';
import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/expense/presentation/pages/add_expense_page.dart';
import '../../features/expense/presentation/pages/expense_list_page.dart';
import '../../features/budget/presentation/pages/budget_page.dart';
import '../../features/goals/presentation/pages/goals_page.dart';
import '../../features/goals/presentation/pages/create_goal_page.dart';
import '../../features/insights/presentation/pages/insights_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/edit_profile_page.dart';
import '../../features/settings/presentation/pages/change_password_page.dart';

// ── Router refresh notifier ───────────────────────────────────────────────
// Re-evaluates redirects whenever the Firebase auth stream emits.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen<AsyncValue<Object?>>(
      authStateProvider,
      (_, __) => notifyListeners(),
    );
  }
}

bool _isAuthRoute(String loc) =>
    loc == RouteNames.login ||
    loc == RouteNames.signup ||
    loc == RouteNames.forgotPassword;

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final authAsync = ref.read(authStateProvider);
      final loading = authAsync.isLoading;
      final loggedIn = authAsync.valueOrNull != null;
      final loc = state.matchedLocation;

      // Splash: hold until auth resolves, then route by auth status.
      if (loc == RouteNames.splash) {
        if (loading) return null;
        return loggedIn ? RouteNames.home : RouteNames.login;
      }

      // While the initial auth state is unknown, don't bounce the user.
      if (loading) return null;

      final onAuthScreen = _isAuthRoute(loc);
      if (!loggedIn && !onAuthScreen) return RouteNames.login;
      if (loggedIn && onAuthScreen) return RouteNames.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (_, __) => const SignupPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (_, __) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.insights,
        builder: (_, __) => const InsightsPage(),
      ),
      GoRoute(
        path: RouteNames.addExpense,
        builder: (_, __) => const AddExpensePage(),
      ),
      GoRoute(
        path: RouteNames.expenseList,
        builder: (_, __) => const ExpenseListPage(),
      ),
      GoRoute(
        path: RouteNames.budget,
        builder: (_, __) => const BudgetPage(),
      ),
      GoRoute(
        path: RouteNames.goals,
        builder: (_, __) => const GoalsPage(),
      ),
      GoRoute(
        path: RouteNames.createGoal,
        builder: (_, __) => const CreateGoalPage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        builder: (_, __) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (_, __) => const EditProfilePage(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        builder: (_, __) => const ChangePasswordPage(),
      ),
    ],
  );
});
