

import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Define routes
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: SignupScreen.routeName,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: DashboardScreen.routeName,
      builder: (context, state) => DashboardScreen(),
    )
  ],
);