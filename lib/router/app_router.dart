import 'package:go_router/go_router.dart';

import '../screens/home_dashboard.dart';
import '../screens/signup_screen.dart';
import '../screens/login_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeDashboardScreen(),
    ),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  ],
);
