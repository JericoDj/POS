import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/forgot_password_screen.dart';
import '../screens/home_dashboard.dart';
import '../screens/splash_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/business/create_business_screen.dart';
import '../screens/business/manage_organizations_screen.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isAuth = authProvider.isAuthenticated;
      final isSplash = state.uri.toString() == '/splash';
      final isLogin = state.uri.toString() == '/login';
      final isSignup = state.uri.toString() == '/signup';
      final isForgot = state.uri.toString() == '/forgot-password';

      if (!isAuth && !isLogin && !isSignup && !isForgot && !isSplash) {
        return '/login';
      }

      if (isAuth && (isLogin || isSignup || isForgot || isSplash)) {
        // user is logged in
        // Check if user has a business
        if (authProvider.user?.businessId == null) {
          return '/business/create';
        }
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeDashboardScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/business/create',
        builder: (context, state) => const CreateBusinessScreen(),
      ),
      GoRoute(
        path: '/business/manage',
        builder: (context, state) => const ManageOrganizationsScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
    ],
  );
}
